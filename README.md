<div align="center">
  <h1>
      <img src="https://skillicons.dev/icons?i=wordpress" alt="Wordpress" /></img>
      WordPress em Alta Disponibilidade na AWS</h1>
  <a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=aws,docker,linux,wordpress,shell" alt="My Skills" style="margin-top: 20px;" />
  </a>
</div>

<p>Este projeto utiliza a <a href="https://hub.docker.com/_/wordpress">imagem oficial do WordPress</a> para criar uma aplicação via <strong>Docker Compose</strong>, distribuída em múltiplas instâncias <strong>EC2</strong> gerenciadas por um <strong>Auto Scaling Group (ASG)</strong>. O balanceamento de carga é feito por um <strong>Application Load Balancer (ALB)</strong>. O armazenamento de arquivos é centralizado via <strong>Amazon Elastic File System (EFS)</strong>. O banco de dados da aplicação é hospedado em um <strong>Amazon RDS (MySQL)</strong>.</p>

<p>- O balanceamento de carga é feito por um <strong>Application Load Balancer (ALB)</strong>.<br>
- O armazenamento de arquivos é centralizado via <strong>Amazon Elastic File System (EFS)</strong>.<br>
- O banco de dados da aplicação é hospedado em um <strong>Amazon RDS (MySQL)</strong>.</p>

<div align="center">
  <img alt="Arquitetura do projeto" src="https://github.com/user-attachments/assets/5878c3fa-9bf0-43a6-9bec-8f4507078439"/>
  <br />
  <i>Figura 1 - Arquitetura de alta disponibilidade do WordPress na AWS</i>
</div>

> [!TIP]  
> Caso tenha dificuldade, recomendo dar uma olhada no meu repositório com <strong>resumos dos principais serviços da AWS</strong>:
> 
> 👉 [Cloud and AWS notes](https://github.com/Lr0cha/aws-cloud-notes)

---

## 📑 Etapas do Projeto

### 🔹 Infraestrutura Base
1. [Criação da **VPC** e subnets (públicas e privadas)](docs/01-aws-vpc.md)    
2. [Configuração de **Security Groups** para cada camada](docs/05-aws-sgs.md)  

### 🔹 Camada de Aplicação e Dados
3. [Configuração inicial de uma instância **EC2** para testes e criação do **User Data**](docs/02-aws-test-ec2.md)
4. [Provisionamento do banco de dados no **Amazon RDS (MySQL)**](docs/03-aws-rds.md)  
5. [Configuração do **Amazon EFS** para armazenamento compartilhado](docs/04-aws-efs.md)
6. [Configuração Launch Template](docs/06-launch-template.md)
7. [Configuração do **ALB (Application Load Balancer)**](docs/07-aws-elb.md)
8. [Configuração do **Auto Scaling Group (ASG)** integrado ao **ALB**](docs/08-aws-elb.md)


## ✅ Resultado Final

Após toda a configuração da infraestrutura, o WordPress ficou disponível de forma **altamente disponível e escalável**:

<div align="center">
  <img alt="WordPress rodando na arquitetura de alta disponibilidade" src="https://github.com/user-attachments/assets/76eb958f-12b9-47f2-a747-306470019c30"/>
  <br />
  <i>Figura 2 – WordPress acessível via ALB na arquitetura de alta disponibilidade</i>
</div>

> [!IMPORTANT]\
> Por razões de custos apaguei toda a infraestrutura, então não tenho uma url que você poderá acessar.


## Melhorias Futuras

- Otimização de custos e monitoramento com **CloudWatch**
- Automação da infraestrutura usando **CloudFormation** ou **Terraform**   

> [!IMPORTANT]\
> Alguns recursos (como NAT Gateway e Elastic IPs) podem gerar <strong>custos significativos</strong>.  
>
> Consulte sempre a [tabela oficial de preços da AWS](https://aws.amazon.com/pricing/) antes usar.
