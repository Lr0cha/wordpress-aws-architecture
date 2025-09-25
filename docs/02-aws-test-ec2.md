<div align="center">
  <h1>Elastic Compute Cloud (EC2) Inicial</h1>
</div>

> [!IMPORTANT]\
> Esta instância foi utilizada apenas para criação do **User Data** e testes com os outros serviços da arquitetura.  
> 👉 Não é necessário reproduzir esta etapa no ambiente final.

### 1. Acessando o serviço
No painel principal da AWS, pesquise e clique em **EC2**.

<details>
<summary>📷 Tela inicial</summary>

<div align="center">
  <img alt="Tela inicial do EC2" src="https://github.com/user-attachments/assets/4aaf2b0f-ad09-407d-aced-e20e1afdc872" width="80%" />
  <br />
  <i>Figura 1 – Tela inicial do serviço EC2</i>
</div>

</details>

---

### 2. Criando a instância
Clique em **Launch instances** e configure:

- **AMI:** Amazon Linux 2023  
- **Tipo de instância:** `t2.micro`  
- **Key Pair:** crie uma nova para acesso SSH  
- **Rede:** selecione a **VPC criada** anteriormente, use **subnet pública**, habilite **Public IP** e crie um SG temporário  
- **Armazenamento:** `1x 8 GiB gp3`  

<details>
<summary>📷 Algumas configurações</summary>

<div align="center">
  <img alt="Configurações da instância" src="https://github.com/user-attachments/assets/c1274fb7-f9d9-4335-80ef-a130cd25cef0" width="80%" />
  <br />
  <i>Figura 2 – Configurações principais da instância</i>
</div>

</details>

Finalize clicando em **Launch instance**.

---

### 3. Instalação do Docker e Docker Compose

Na instância, rode:

```bash
# Atualizar pacotes
sudo dnf update -y

# Instalar Docker
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Instalar Docker Compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.39.3/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
````

> [!NOTE]
> Para evitar usar `sudo` sempre, adicione o usuário ao grupo `docker`:
>
> ```bash
> sudo usermod -aG docker ec2-user
> ```

<details>
<summary>📷 Ver imagem</summary>

<div align="center">
  <img alt="Instalação do Docker e Docker Compose" src="https://github.com/user-attachments/assets/b117c0a4-b129-4499-b3e9-45daa05f7553" width="80%" />
  <br />
  <i>Figura 3 – Instalação do Docker e Docker Compose</i>
</div>

</details>

---

### 4. Configuração do Docker Compose para WordPress

Crie a pasta e o arquivo de configuração:

```bash
mkdir wordpress-docker
cd wordpress-docker
nano docker-compose.yml
```

Cole:

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

> Salve no `nano` com: `CTRL + O` → `ENTER` → `CTRL + X`

---

### 5. Inicialização e acesso ao WordPress

Suba os containers:

```bash
sudo docker-compose up -d
```

Depois acesse no navegador:

```
http://<IP-PUBLICO-EC2>:8080
```

🎉 Você verá a tela de configuração inicial do **WordPress**.

<div align="center">
  <img alt="Tela inicial do WordPress" src="https://github.com/user-attachments/assets/b0114b8c-9288-4a88-ae0f-45de3842a4a4" width="80%" />
  <br />
  <i>Figura 10 – Tela inicial do WordPress acessível na porta 8080</i>
</div>

<div align="center">
  <a href="./01-aws-vpc.md">◀️</a> |
  <a href="./03-aws-rds.md">▶️</a>
</div>
