# 🏢 Oracle PL/SQL Scripts Collection

[![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/)
[![PL/SQL](https://img.shields.io/badge/PL%2FSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://docs.oracle.com/en/database/oracle/oracle-database/)
[![HCM Cloud](https://img.shields.io/badge/HCM%20Cloud-FF6B35?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/human-capital-management/)
[![ERP Cloud](https://img.shields.io/badge/ERP%20Cloud-1F8B4C?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/erp/)

> Uma coleção abrangente de scripts SQL para Oracle Fusion Cloud Applications, incluindo HCM, ERP, e outros módulos essenciais.

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Módulos Disponíveis](#-módulos-disponíveis)
- [Como Usar](#-como-usar)
- [Categorias de Scripts](#-categorias-de-scripts)
- [Pré-requisitos](#-pré-requisitos)
- [Documentação](#-documentação)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

## 🎯 Sobre o Projeto

Este repositório contém uma coleção extensiva de scripts SQL desenvolvidos para Oracle Fusion Cloud Applications, com foco especial em:

- **Oracle HCM Cloud** - Gestão de Capital Humano
- **Oracle ERP Cloud** - Planejamento de Recursos Empresariais
- **Business Intelligence Publisher (BIP)** - Relatórios e Consultas
- **HDL (HCM Data Loader)** - Carregamento de Dados
- **OTBI (Oracle Transactional Business Intelligence)** - Inteligência de Negócios

## 📁 Estrutura do Repositório

```
oracle_pl_sql/
├── 📂 Absences/                    # Scripts para gestão de ausências
├── 📂 Access/                      # Controle de acesso e permissões
├── 📂 Articles/                    # Documentação e artigos técnicos
├── 📂 Assignment/                  # Gestão de atribuições de funcionários
├── 📂 Basics/                      # Funções SQL fundamentais
├── 📂 Console OIC/                 # Oracle Integration Cloud
├── 📂 Contracts/                   # Gestão de contratos
├── 📂 ERP/                         # Scripts para módulos ERP
├── 📂 Estrutura Organizacional/    # Hierarquia organizacional
├── 📂 Fusion/                      # Scripts gerais do Fusion Cloud
├── 📂 Fusion_Cloud_Sql_Scripts/    # Coleção externa de scripts
├── 📂 HCM/                         # Scripts específicos do HCM
├── 📂 HDL/                         # HCM Data Loader scripts
├── 📂 Legal Entities/              # Entidades legais
├── 📂 Reports_Using_BIP/           # Relatórios BIP
├── 📂 Senior/                      # Integração com sistema Senior
├── 📂 SNR/                         # Scripts SNR
├── 📂 Teste/                       # Scripts de teste
├── 📂 Users/                       # Gestão de usuários
└── 📄 README.md                    # Este arquivo
```

## 🚀 Módulos Disponíveis

### 💼 Human Capital Management (HCM)
- **Colaboradores**: Consultas completas de funcionários ativos
- **Ausências**: Gestão e relatórios de ausências
- **Atribuições**: Gestão de cargos e posições
- **Períodos de Serviço**: Histórico laboral
- **Organização**: Estrutura hierárquica

### 💰 Enterprise Resource Planning (ERP)
- **Accounts Payable (AP)**: Contas a pagar
- **Accounts Receivable (AR)**: Contas a receber
- **General Ledger (GL)**: Livro razão
- **Project Accounting (PA)**: Contabilidade de projetos
- **Purchase Orders (PO)**: Ordens de compra

### 📊 Business Intelligence Publisher (BIP)
- **Relatórios de Funcionários**: Dados completos de RH
- **Relatórios Financeiros**: Análises contábeis
- **Extrações HDL**: Formatos para carregamento de dados
- **Consultas OTBI**: Business Intelligence transacional

## 🛠 Como Usar

### 1. Clone o Repositório
```bash
git clone https://github.com/drsfabio/oracle_pl_sql.git
cd oracle_pl_sql
```

### 2. Conecte ao Oracle Fusion Cloud
```sql
-- Exemplo de conexão
CONNECT username/password@your_fusion_instance
```

### 3. Execute os Scripts
```sql
-- Exemplo: Consultar colaboradores ativos
@"Consulta Colaboradores.sql"

-- Exemplo: Extrair dados de ausências
@"BIP - Get Absences Records.sql"
```

## 📊 Categorias de Scripts

| Categoria | Descrição | Quantidade |
|-----------|-----------|------------|
| 👥 **Colaboradores** | Consultas de funcionários e dados pessoais | 15+ scripts |
| 🏖️ **Ausências** | Gestão de licenças e afastamentos | 10+ scripts |
| 📋 **BIP Reports** | Relatórios Business Intelligence | 30+ scripts |
| 🏢 **Organização** | Estrutura empresarial e hierarquia | 8+ scripts |
| 💼 **Atribuições** | Cargos, posições e responsabilidades | 12+ scripts |
| 📈 **ERP Modules** | Módulos financeiros e contábeis | 25+ scripts |
| 🔐 **Segurança** | Usuários, roles e permissões | 10+ scripts |
| 📄 **HDL** | Scripts para carregamento de dados | 5+ scripts |

## ⚙️ Pré-requisitos

- **Oracle Fusion Cloud** - Acesso ao ambiente
- **SQL Developer** ou **Toad** - Cliente SQL
- **Permissões adequadas** - Para execução das consultas
- **Conhecimento básico** - PL/SQL e estruturas Oracle

### Versões Suportadas
- Oracle Fusion Cloud Applications 20A+
- Oracle HCM Cloud
- Oracle ERP Cloud
- Oracle Database 19c+

## 📚 Documentação

### Scripts Principais

#### 👥 Gestão de Colaboradores
```sql
-- Consulta colaboradores completos
"Consulta Colaboradores Completo.sql"

-- Colaboradores ativos para folha
"Consulta Colaboradores Ativos e Ativos para a Folha de Pagamento.sql"

-- Dados cadastrais
"Consulta Dados Cadastrais do Colaborador.sql"
```

#### 🏖️ Gestão de Ausências
```sql
-- Ausências completas
"Consulta Ausencias Completo.sql"

-- Ausências por HDL
"Get Absences Records By HDL SoucesId.sql"

-- Histórico de afastamentos
"BIP - Consolida Historico de Afastamentos.sql"
```

#### 📊 Relatórios BIP
```sql
-- Extração de funcionários com atribuições
"BIP - Extract Employee With Assingnments.sql"

-- Relatório RH01
"BIP - RH01.sql"

-- Usuários e roles
"BIP - Get Users And Roles.sql"
```

### Estruturas de Dados Comuns

#### Tabelas HCM Principais
- `PER_ALL_PEOPLE_F` - Dados pessoais
- `PER_ALL_ASSIGNMENTS_M` - Atribuições
- `PER_PERIODS_OF_SERVICE` - Períodos de serviço
- `HR_ALL_ORGANIZATION_UNITS` - Unidades organizacionais

#### Views ERP Essenciais
- `GL_CODE_COMBINATIONS` - Combinações contábeis
- `AP_INVOICES_ALL` - Faturas a pagar
- `AR_TRANSACTIONS_ALL` - Transações a receber

## 🤝 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. **Fork** o projeto
2. Crie uma **branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. Abra um **Pull Request**

### Diretrizes
- Documente adequadamente seus scripts
- Inclua comentários explicativos
- Teste em ambiente de desenvolvimento
- Siga as convenções de nomenclatura existentes

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Dr. Fábio**
- GitHub: [@drsfabio](https://github.com/drsfabio)
- LinkedIn: [@drsfabio](https://linkedin.com/in/drsfabio)

## 🙏 Agradecimentos

- Oracle Corporation pela documentação e suporte
- Comunidade Oracle para melhores práticas
- Contribuidores que ajudaram a melhorar este repositório

## 📈 Estatísticas

![GitHub repo size](https://img.shields.io/github/repo-size/drsfabio/oracle_pl_sql)
![GitHub language count](https://img.shields.io/github/languages/count/drsfabio/oracle_pl_sql)
![GitHub top language](https://img.shields.io/github/languages/top/drsfabio/oracle_pl_sql)
![GitHub last commit](https://img.shields.io/github/last-commit/drsfabio/oracle_pl_sql)

---

⭐ **Se este repositório foi útil para você, considere dar uma estrela!** ⭐