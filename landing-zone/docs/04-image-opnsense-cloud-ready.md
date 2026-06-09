# 04 — OPNsense Cloud-Ready image

> **⚠️ Unofficial image — user responsibility**
>
> The image currently referenced in `config.tf` (`OPNsense-26.1-cloudready.qcow2`, the version in force at the time this guide was written) is a **community image, neither produced nor validated by the OPNsense project**. It is hosted on an OVHcloud S3 bucket for convenience. **Its use is entirely at your own risk.** No guarantee of integrity, availability or updates is provided. Rebuilding this image yourself from the official OPNsense sources is strongly recommended, following the procedure below.

---

## Why this image exists

OPNsense does not publish a cloud-ready image compatible with OpenStack. The closest official image (`nano-amd64`) is designed for bare-metal or classic VM environments: it does not read the **OpenStack config-drive** (`/dev/iso9660/config-2`) and therefore cannot inject a configuration at first boot through `user_data`.

To integrate OPNsense into an OVHcloud Public Cloud (OpenStack) environment, a bootstrap mechanism must be added that:

1. mounts the OpenStack config-drive at boot,
2. copies the `user_data` file (an OPNsense `config.xml`) to `/conf/config.xml`,
3. forces a reboot so that OPNsense loads the configuration cleanly.

---

## What the image contains

| Component | Detail |
|-----------|--------|
| **Base** | Official OPNsense nano-amd64 image (downloaded from `pkg.opnsense.org`) |
| **Addition** | `08-custom-bootstrap` script injected into `/usr/local/etc/rc.syshook.d/early/` |
| **Format** | Compressed qcow2 (`qemu-img convert -c`) |
| **Storage** | Public OVHcloud S3 bucket (`eu-west-par`) |

The image contains no pre-filled OPNsense configuration: it starts in a clean state and waits for a configuration through the config-drive.

---

## How the bootstrap works at first boot

The `08-custom-bootstrap` script runs in the `early` phase of `rc.syshook` (before the OPNsense services start):

1. **Idempotent guard** — if `/root/.bootstrap_done` exists, the script does nothing (prevents overwriting the configuration on later reboots).
2. **Production guard** — if `/conf/config.xml` was modified more than 10 minutes ago, the system is considered to be in production and the bootstrap is aborted.
3. **Config-drive wait** — waits up to 10 seconds for `/dev/iso9660/config-2` to become available.
4. **Injection** — mounts the config-drive, copies `openstack/latest/user_data` to `/conf/config.xml`, drops the `/root/.bootstrap_done` flag, unmounts, then **reboots**.

The reboot is intentional: it ensures the OPNsense kernel and every network interface load the new configuration from a clean state.

---

## Rebuilding the image yourself

### Prerequisites

- A FreeBSD instance (OVHcloud Public Cloud or other) with:
  - `qemu-img` (`qemu-utils` or `qemu` package on FreeBSD)
  - `aws` CLI configured with the credentials of your OVHcloud S3 bucket
- An OVHcloud S3 bucket with public read access (or private if you adapt `config.tf`)

### Build script — `build-cloud-img.sh`

```bash
#!/usr/local/bin/bash
# ================================================
# OPNsense → qcow2 Cloud-Ready (FreeBSD runner)
# Usage: ./build-cloud-img.sh <version>  ex: ./build-cloud-img.sh 26.1.2
# ================================================

set -euo pipefail

VERSION="${1?Usage: $0 <version>}"
WORK_DIR="/tmp/opnsense-build-$$"
BOOTSTRAP_SRC="/root/08-custom-bootstrap"
BUCKET="opnsense"                               # ← adapt to your bucket
S3_ENDPOINT="https://s3.eu-west-par.io.cloud.ovh.net/"  # ← adapt to your region
S3_HOST="s3.eu-west-par.io.cloud.ovh.net"               # ← same value, without https:// nor /
S3_PATH="releases-cloudready"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

RAW_IMG="OPNsense-${VERSION}-nano-amd64.img"
QCOW2_FILE="OPNsense-${VERSION}-cloudready.qcow2"

echo "=== Build OPNsense ${VERSION} qcow2 Cloud-Ready ==="

# 1. Download the official nano image
fetch "https://pkg.opnsense.org/releases/${VERSION}/OPNsense-${VERSION}-nano-amd64.img.bz2" \
  -o "${RAW_IMG}.bz2"

# 2. Verify the official OPNsense checksum
echo "→ Verifying checksum..."
fetch "https://pkg.opnsense.org/releases/${VERSION}/OPNsense-${VERSION}-checksums-amd64.sha256" \
  -o checksums.sha256
EXPECTED=$(grep "nano-amd64.img.bz2" checksums.sha256 | awk '{print $1}')
ACTUAL=$(sha256 -q "${RAW_IMG}.bz2")
[ "${EXPECTED}" = "${ACTUAL}" ] || { echo "ERROR: invalid checksum — image corrupted or modified."; exit 1; }
echo "✓ Checksum OK."
rm -f checksums.sha256

# 3. Decompress
bunzip2 -f "${RAW_IMG}.bz2"

# 4. Inject the bootstrap script
echo "→ Injecting 08-custom-bootstrap..."
ID=$(mdconfig -a -t vnode -f "${RAW_IMG}")
mount /dev/"${ID}"a /mnt

cp "${BOOTSTRAP_SRC}" /mnt/usr/local/etc/rc.syshook.d/early/
chmod 755 /mnt/usr/local/etc/rc.syshook.d/early/08-custom-bootstrap
chown root:wheel /mnt/usr/local/etc/rc.syshook.d/early/08-custom-bootstrap

umount /mnt
mdconfig -d -u "${ID}"

# 5. Convert raw → compressed qcow2
echo "→ Converting raw → qcow2..."
qemu-img convert -f raw -O qcow2 -c "${RAW_IMG}" "${QCOW2_FILE}"

# 6. Upload to OVHcloud S3 (public read access)
echo "→ Uploading to S3..."
aws --endpoint-url "${S3_ENDPOINT}" s3 cp "${QCOW2_FILE}" \
    "s3://${BUCKET}/${S3_PATH}/${QCOW2_FILE}" --acl public-read

# 7. Cleanup
echo "→ Cleaning up..."
rm -f "${RAW_IMG}"* "${QCOW2_FILE}"
rmdir "$WORK_DIR" 2>/dev/null || true

echo "✅ Done!"
echo "URL: https://${BUCKET}.${S3_HOST}/${S3_PATH}/${QCOW2_FILE}"
```

### Bootstrap script — `08-custom-bootstrap`

This file must be placed at `/root/08-custom-bootstrap` on the FreeBSD runner before launching the build script.

```sh
#!/bin/sh

# 1. Idempotence: do nothing if already bootstrapped
if [ -f /root/.bootstrap_done ]; then
    exit 0
fi

# 2. Safety check: do not overwrite a config older than 10 minutes
if [ -f /conf/config.xml ]; then
    CONFIG_AGE=$(stat -f "%m" /conf/config.xml)
    NOW=$(date +%s)
    AGE=$((NOW - CONFIG_AGE))
    if [ $AGE -gt 600 ]; then
        echo "System already in production (config > 10 min). Bootstrap aborted."
        touch /root/.bootstrap_done
        exit 0
    fi
fi

# 3. Wait for the OpenStack config-drive (max 10 s)
DEVICE="/dev/iso9660/config-2"
MAX_TRIES=10
COUNTER=0

echo "Waiting for Config Drive ($DEVICE)..."
while [ ! -e "$DEVICE" ] && [ $COUNTER -lt $MAX_TRIES ]; do
    sleep 1
    COUNTER=$((COUNTER + 1))
done

if [ ! -e "$DEVICE" ]; then
    echo "ERROR: $DEVICE not found after ${MAX_TRIES}s."
    exit 1
fi

# 4. Mount and inject the configuration
mkdir -p /mnt/configdrive
mount_cd9660 /dev/iso9660/config-2 /mnt/configdrive

if [ -f /mnt/configdrive/openstack/latest/user_data ]; then
    cp /mnt/configdrive/openstack/latest/user_data /conf/config.xml
    touch /root/.bootstrap_done
    umount /mnt/configdrive
    echo "Configuration injected. Rebooting..."
    reboot
else
    echo "No user_data found, normal boot."
    umount /mnt/configdrive
fi
```

---

## Pointing to your own image in `config.tf`

Once your image is uploaded, change the `image_source_url` variable in [modules/firewall/opnsense-ha/config.tf](../modules/firewall/opnsense-ha/config.tf):

```hcl
resource "openstack_images_image_v2" "fw_image" {
  name             = "OPNsense Cloud-Ready"
  image_source_url = "https://<your-bucket>.s3.<your-region>.io.cloud.ovh.net/releases-cloudready/OPNsense-<version>-cloudready.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
}
```

Replace `<your-bucket>`, `<your-region>` and `<version>` with your values.
