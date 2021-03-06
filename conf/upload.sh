#!/bin/bash
# Linted by https://www.shellcheck.net/

# This script aims to harvest .json files generated by logrotate,
# compress and upload them to S3.

if [[ -z "${DATA_DIR}"  ||  -z "${AWS_S3_DIR}"  ||  -z "${AWS_ACCESS_KEY_ID}"  ||  -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
  sleep infinity
fi

# Infinite while loop
while :
do
  sleep 60
  # Find .json files and compress them
  find $DATA_DIR -name "*.json" -type f | shuf | xargs -r -n 1 pigz -f
  rclone move $DATA_DIR $AWS_S3_DIR --include '*.json.gz' --no-traverse
done
