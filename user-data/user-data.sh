#!/bin/bash

EC2_USER_DIR="/home/ec2-user"  

sudo dnf update -y

sudo dnf install -y awscli

# Parameter Store var
EFS_FILE_SYSTEM_ID=$(aws ssm get-parameter --name "/wordpress/efs/id" --region us-east-1 --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/wordpress/db/host" --region us-east-1 --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/wordpress/db/name" --region us-east-1 --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/wordpress/db/user" --region us-east-1 --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --with-decryption --name "/wordpress/db/password" --region us-east-1 --query "Parameter.Value" --output text)

#docker and docker-compose setup
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# efs mount
sudo dnf install -y amazon-efs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs -o tls ${EFS_FILE_SYSTEM_ID}:/ /mnt/efs

# automatic efs mounting
echo "${EFS_FILE_SYSTEM_ID}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab


# grant access to the container (www-data) efs
chown -R 33:33 /mnt/efs

mkdir -p ${EC2_USER_DIR}/wordpress-docker && cd ${EC2_USER_DIR}/wordpress-docker
touch docker-compose.yml

# docker-compose.yml
cat > docker-compose.yml <<EOL
services:
  wordpress:
    image: wordpress
    restart: always
    container_name: wordpress
    environment:
      WORDPRESS_DB_HOST: ${DB_HOST}
      WORDPRESS_DB_NAME: ${DB_NAME}
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
    ports:
      - 80:80
    volumes:
      - /mnt/efs:/var/www/html
EOL

# init
sudo docker-compose up -d
