#!/bin/bash

# Stop on error and display executed commands
set -eo xtrace

terraform destroy -auto-approve
