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

```bash
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
```
> [!IMPORTANT]\
> Foi utilizado o **AWS Systems Manager Parameter Store** para armazenar variáveis de forma segura, evitando hardcode no código.  
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

Caso também vá utilizar **Parameter Store** e **Systems manager** para ssh, crie uma **IAM Role** com permissões para acessar:
Exemplo de policy customizada para os parâmetros do projeto WordPress:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
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

Além disso, associe a policy **`AmazonSSMManagedInstanceCore`** para:

* Permitir acesso via **SSM Session Manager (SSH no navegador sem precisar de chave privada)**.
* Executar comandos remotos no EC2.

> [!IMPORTANT]
> O Launch Template será usado pelo **Auto Scaling Group**, então todas as permissões e scripts configurados nele se replicam automaticamente em cada nova instância criada.
