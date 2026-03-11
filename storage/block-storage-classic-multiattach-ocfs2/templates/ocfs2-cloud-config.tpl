## template: jinja
#cloud-config
users:
- default

package_update: true

packages:
- ocfs2-tools
- linux-modules-extra-{{ v1.kernel_release }}

write_files:
- path: /etc/ocfs2/cluster.conf
  content: |
    cluster:
        name = ocfs2
        heartbeat_mode = local
        node_count = 3

    node:
        number = 1
        name = ${SERVER_1_NAME}
        ip_address = ${SERVER_1_IP}
        ip_port = 7777
        cluster = ocfs2
    
    node:
        number = 2
        name = ${SERVER_2_NAME}
        ip_address = ${SERVER_2_IP}
        ip_port = 7777
        cluster = ocfs2
    
    node:
        number = 3
        name = ${SERVER_3_NAME}
        ip_address = ${SERVER_3_IP}
        ip_port = 7777
        cluster = ocfs2

runcmd:
- sed -i -e 's/O2CB_ENABLED=false/O2CB_ENABLED=true/g' /etc/default/o2cb
- systemctl restart o2cb
- mkfs.ocfs2 -N 6 /dev/sdb
- mount.ocfs2 /dev/sdb /mnt
- echo "/dev/sdb /mnt ocfs2 _netdev,defaults 0 0" >> /etc/fstab