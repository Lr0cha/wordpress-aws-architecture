<div align="center">
  <h1>Elastic Compute Cloud (EC2) Inicial</h1>
</div>

> [!IMPORTANT]\
> Esta instância foi utilizada apenas para criação do **User Data** e testes com os outros serviços contemplados na arquitetura.
> 👉 Não é necessário reproduzir esta etapa no seu ambiente final.

### 1. Acessando o serviço
No painel principal da AWS, pesquise e clique em **EC2**.

<div align="center">
  <img alt="Tela inicial do EC2" src="https://github.com/user-attachments/assets/4aaf2b0f-ad09-407d-aced-e20e1afdc872" width="80%" />
  <br />
  <i>Figura 1 – Tela inicial do serviço EC2</i>
</div>

---

### 2. Criando a instância
Clique em **Launch instances** para iniciar a configuração.

- **AMI:** `Amazon Linux`
- **Versão utilizada:** `Amazon Linux 2023 AMI`
- **Tipo de instância:** `t2.micro`

<div align="center">
  <img alt="Seleção da AMI e tipo de instância" src="https://github.com/user-attachments/assets/541ee394-d292-4db5-b886-927be3b4be20" width="80%" />
  <br />
  <i>Figura 2 – Seleção da AMI e tipo de instância</i>
</div>

---

### 3. Criando a Key Pair
Crie uma nova **Key Pair** para permitir acesso SSH à instância.

<div align="center">
  <img alt="Criação de Key Pair" src="https://github.com/user-attachments/assets/c49466b8-63e4-4641-8211-064b26539ef2" width="80%" />
  <br />
  <i>Figura 3 – Criação de Key Pair</i>
</div>

---

### 4. Configurações de rede
- **VPC:** selecione a criada na primeira etapa. 
- **Subnet:** alguma das subnets públicas 
- **Auto-assign Public IP:** `Enable`
- **Firewall:** selecione **Create security group** para testes 

<div align="center">
  <img alt="Configurações de rede" src="https://github.com/user-attachments/assets/c1274fb7-f9d9-4335-80ef-a130cd25cef0" width="80%" />
  <br />
  <i>Figura 4 – Configurações de rede da instância</i>
</div>

---

### 5. Armazenamento
Verifique se o **Configure storage** está definido como:

- `1x 8 GiB gp3`

---

### 6. Revisão e criação
- Revise todas as configurações
- Clique em **Launch instance** para criar a instância

<div align="center">
  <img alt="Revisão e lançamento da instância" src="https://github.com/user-attachments/assets/eb545334-5d44-4d90-8858-34b3d98d57b1" />
  <br />
  <i>Figura 5 – Revisão e criação da instância EC2</i>
</div>

---

### 7. Instalação do Docker e Docker Compose

Execute os comandos abaixo na sua instância **EC2**:

```bash
# Atualizar pacotes do sistema
sudo dnf update -y

# Instalar o Docker
sudo dnf install -y docker

# Iniciar o serviço do Docker
sudo systemctl start docker

# Habilitar o Docker para iniciar junto com o sistema
sudo systemctl enable docker

# Baixar o Docker Compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# Dar permissão de execução ao binário do Docker Compose
sudo chmod +x /usr/local/bin/docker-compose
```

> [!IMPORTANT]\
> Usei a versão do docker compose 2.39.3, caso queira mudar procure no repositório: https://github.com/docker/compose/releases
>
 
> [!NOTE]\
> Caso queira evitar o uso do `sudo` em todos os comandos Docker, adicione seu usuário ao grupo `docker`:
>
> ```bash
> sudo usermod -aG docker ec2-user
> ```

<div align="center">
  <img alt="Instalação do Docker e Docker Compose" src="https://github.com/user-attachments/assets/b117c0a4-b129-4499-b3e9-45daa05f7553" width="80%" />
  <br />
  <i>Figura 6 – Instalação do Docker e Docker Compose</i>
</div>

---

### 8. Configuração do Docker Compose para WordPress

O projeto utilizará o [Docker Hub oficial do WordPress](https://hub.docker.com/_/wordpress).

Crie a estrutura de diretórios e arquivo:

```bash
# Criar diretório para o projeto
mkdir wordpress-docker

# Acessar o diretório
cd wordpress-docker

# Criar arquivo de configuração do Docker Compose
nano docker-compose.yml
```

<div align="center">
  <img alt="Edição do arquivo docker-compose.yml" src="https://github.com/user-attachments/assets/d6aaa76e-94c5-47fa-8f07-2cfecc3c0997" width="80%" />
  <br />
  <i>Figura 7 – Estrutura do diretório</i>
</div>

Cole no arquivo a configuração abaixo:

```yaml
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress:/var/www/html

  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql

volumes:
  wordpress:
  db:
```

> Salve o arquivo no `nano` com:
> `CTRL + O` → `ENTER` → `CTRL + X`

<div align="center">
  <img alt="Edição do arquivo docker-compose.yml" src="https://github.com/user-attachments/assets/6774c0c2-e162-4118-bd78-59cb8b80fb3d" width="80%" />
  <br />
  <i>Figura 8 – Edição do arquivo docker-compose.yml</i>
</div>

---

### 9. Inicialização dos containers

Execute o comando abaixo para subir os containers em segundo plano:

```bash
sudo docker-compose up -d
```

<div align="center">
  <img alt="Execução do docker-compose up" src="https://github.com/user-attachments/assets/3cf8ba3e-b766-47b1-830d-d7994b23341e" />
  <br />
  <i>Figura 9 – Inicialização dos containers com Docker Compose</i>
</div>

---

### 10. Acessando o WordPress

Acesse o **IP público da sua instância EC2** na porta **8080**:

```
http://<IP-PUBLICO-EC2>:8080
```

Você verá a tela inicial de configuração do **WordPress** 🎉

<div align="center">
  <img alt="Tela inicial do WordPress" src="https://github.com/user-attachments/assets/b0114b8c-9288-4a88-ae0f-45de3842a4a4" width="80%" />
  <br />
  <i>Figura 10 – Tela inicial do WordPress acessível na porta 8080</i>
</div>


