#!/usr/bin/env bash

# bash strict mode params
set -euo pipefail

# install and update packages
apt-get update -y
apt-get install -y unzip certbot

# install AWSCLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install
rm -rf ./awscliv2.zip

# certbot command
echo "INFO: BEGINNING CERTBOT TASK."
certbot certonly \
  --preferred-chain "ISRG Root X1" \
  --non-interactive \
  --standalone \
  --preferred-challenges http \
  --domain ${cert_fqdn} \
  -m ${cert_email} \
  --agree-tos \
  --no-eff-email

# copy cert files to S3
CERTS_PATH="/etc/letsencrypt/live/${cert_fqdn}"
aws s3 cp "$CERTS_PATH/cert.pem" "s3://${output_bucket}/cert.pem"
aws s3 cp "$CERTS_PATH/chain.pem" "s3://${output_bucket}/chain.pem"
aws s3 cp "$CERTS_PATH/fullchain.pem" "s3://${output_bucket}/fullchain.pem"
aws s3 cp "$CERTS_PATH/privkey.pem" "s3://${output_bucket}/privkey.pem"