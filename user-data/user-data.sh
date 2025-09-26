#!/bin/bash

EC2_USER_DIR="/home/ec2-user"
LOG_FILE="/var/log/wordpress-install.log"
exec > >(tee -a $LOG_FILE) 2>&1  # Redirecionar stdout/err

log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1"
}

log "Iniciando a instalacao..."

log "Atualizando o sistema..."
sudo dnf update -y


log "Instalando o AWS CLI..."
sudo dnf install -y awscli

log "Obtendo parametros do SSM Parameter Store..."
EFS_FILE_SYSTEM_ID=$(aws ssm get-parameter --name "/wordpress/efs/id" --region us-east-1 --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/wordpress/db/host" --region us-east-1 --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/wordpress/db/name" --region us-east-1 --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/wordpress/db/user" --region us-east-1 --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --with-decryption --name "/wordpress/db/password" --region us-east-1 --query "Parameter.Value" --output text)

log "Instalando Docker..."
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker

log "Instalando Docker Compose..."
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


log "Instalando o utilitario amazon-efs-utils..."
sudo dnf install -y amazon-efs-utils

log "Criando ponto de montagem para o EFS em /mnt/efs..."
sudo mkdir -p /mnt/efs
log "Montando o EFS..."
sudo mount -t efs -o tls ${EFS_FILE_SYSTEM_ID}:/ /mnt/efs

log "Configurando montagem automatica do EFS..."
echo "${EFS_FILE_SYSTEM_ID}:/ /mnt/efs efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab

log "Concedendo permissoes de acesso ao EFS para o container..."
sudo chown -R 33:33 /mnt/efs

log "Criando diretorio do projeto WordPress..."
mkdir -p ${EC2_USER_DIR}/wordpress-docker && cd ${EC2_USER_DIR}/wordpress-docker

log "Criando arquivo docker-compose.yml..."
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

log "Iniciando o container WordPress com Docker Compose..."
sudo docker-compose up -d
