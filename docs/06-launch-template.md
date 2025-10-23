<div align="center">
<h1>Launch Template</h1>
</div>

1. No console da AWS, pesquise por **EC2** e vá em **Launch Templates**.  
2. Clique em **`Create Launch Template`**.  

---

### Configurações principais

- **Nome:** Defina um identificador único para o template.  
- **AMI:** Selecione uma imagem baseada em Linux (ex.: **Amazon Linux 2023**).  
- **Tipo de instância:** No meu caso `t2.micro`. 
- **Key Pair:** Não utilizei, pois usarei **SSM Session Manager**.  
- **Security Group:** Selecione o [**ec2-template-sg**](./05-aws-sgs.md) criado.  

---

### User Data

Adicione o script para inicialização da instância no campo **Advanced details → User data**. 
* Caso prefira este foi o script que usei:

```bash
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
```
> [!IMPORTANT]\
> Foi utilizado o **AWS Systems Manager Parameter Store** para armazenar variáveis de forma segura, evitando hardcode no código.
>  
> Por exemplo:  
>
> ```bash
> EFS_FILE_SYSTEM_ID=$(aws ssm get-parameter \
>   --name "/wordpress/efs/id" \
>   --region us-east-1 \
>   --query "Parameter.Value" \
>   --output text)
> ```
>
> Caso prefira, você pode substituir pelo valor fixo diretamente:  
>
> ```bash
> EFS_FILE_SYSTEM_ID="id-do-efs"
> ```

> [!NOTE]\
> O **User Data** é executado apenas no **primeiro boot da instância**.  
> Ele pode ser usado para instalar pacotes, montar o **EFS** e recuperar variáveis do **Parameter Store** automaticamente.


---

### IAM Role e Policies

Caso também vá utilizar **Parameter Store** e **Session manager** para ssh, crie uma **IAM Role** com permissões para acessar:
* Exemplo de policy customizada para os parâmetros do projeto:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SSMBasics",
            "Effect": "Allow",
            "Action": [
                "ssm:UpdateInstanceInformation",
                "ssm:GetDocument",
                "ssm:PutInventory",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SSMSessionManager",
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ParameterStoreReadWordPress",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath"
            ],
            "Resource": [
                "arn:aws:ssm:us-east-1:<id-da-sua-conta>:parameter/wordpress/*"
            ]
        },
        {
            "Sid": "KMSDecryptDefaultSSMKey",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1:<id-da-sua-conta>:alias/aws/ssm"
            ]
        }
    ]
}
```

> [!IMPORTANT]
> O Launch Template será usado pelo **Auto Scaling Group**, então todas as permissões e scripts configurados nele se replicam automaticamente em cada nova instância criada.

<div align="center">
  <a href="./05-aws-sgs.md">◀️</a> |
  <a href="./07-aws-elb.md">▶️</a>
</div>
