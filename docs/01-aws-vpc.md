<div align="center">
  <h1>Criação da Infraestrutura da VPC</h1>
</div>

---

### 1. Acessando o serviço
No painel principal da AWS, pesquise e clique em **VPC**.

<div align="center">
  <img alt="Tela inicial do serviço VPC" src="https://github.com/user-attachments/assets/a6171da5-4206-4d94-a421-e0cb7c07e99e" width="80%" />
  <br />
  <i>Figura 1 – Tela inicial do serviço VPC na AWS</i>
</div>

---

### 2. Criando a VPC
Na página da VPC, clique em **Create VPC**. 
Selecione a opção **VPC and more** e configure:

- **Nome da VPC:** escolha um identificador 
- **IPv4 CIDR:** `10.0.0.0/16` (padrão sugerido) 
- **IPv6 Block:** pode deixar desabilitado 
- **Tenancy:** `Default`

<div align="center">
  <img alt="Criação da VPC" src="https://github.com/user-attachments/assets/e6a7fb14-6a59-47dc-892a-0fad198a30a5" />
  <br />
  <i>Figura 2 – Configurações iniciais da VPC</i>
</div>

---

### 3. Configurações de rede

- **Availability Zones (AZs):** `2` 

> [!IMPORTANT]\
> Neste projeto foi utilizada a região **N. Virgínia** (`us-east-1a` e `us-east-1b`).

- **Subnets públicas:** `2` 
- **Subnets privadas:** `4` 

> [!NOTE]\
> No meu caso as 4 subnets privadas foram divididas em dois grupos: **storage** e **aplicação**, mas pode ser usado somente 2 também.

- **NAT Gateways:** `1 por AZ` 
- **VPC Endpoints:** `None`
- Clique em `create VPC` para finalizar a criação.

<div align="center">
  <img alt="Configurações de rede" src="https://github.com/user-attachments/assets/716d7ed0-0883-4c8a-b6ea-250b326da54f" />
  <br />
  <i>Figura 3 – Configurações adicionais da rede</i>
</div>

---

### 4. Resultado final

O **Resource Map** da infraestrutura ficará assim:

<div align="center">
  <img alt="Resource map da VPC" src="https://github.com/user-attachments/assets/aad89676-fa3d-438d-bf98-250634957c59"/>
  <br />
  <i>Figura 4 – Mapa de recursos gerado para a VPC</i>
</div>

> [!IMPORTANT]\
> Os custos de `NAT GATEWAY` e `IP ELÁSTICO` podem ser mais elevados sendo um ponto de atenção importante.
> 
> Saiba mais em: [AWS VPC Pricing](https://aws.amazon.com/vpc/pricing/)

