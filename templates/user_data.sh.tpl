#!/usr/bin/env bash

# bash strict mode params
set -euo pipefail

# install and update packages
echo "[INFO] Beginning user_data script."
apt-get update -y
apt-get install -y unzip
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

# install AWSCLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install
rm -rf ./awscliv2.zip

# certbot command
echo "[INFO] Running certbot."
certbot certonly \
  --key-type rsa \
  --non-interactive \
  --standalone \
  --preferred-challenges http \
  --domain ${cert_fqdn} \
  --email ${cert_email} \
  --agree-tos \
  --no-eff-email

# copy cert files to S3
CERTS_PATH="/etc/letsencrypt/live/${cert_fqdn}"
aws s3 cp "$CERTS_PATH/cert.pem" "s3://${output_bucket}/cert.pem"
aws s3 cp "$CERTS_PATH/chain.pem" "s3://${output_bucket}/chain.pem"
aws s3 cp "$CERTS_PATH/fullchain.pem" "s3://${output_bucket}/fullchain.pem"
aws s3 cp "$CERTS_PATH/privkey.pem" "s3://${output_bucket}/privkey.pem"