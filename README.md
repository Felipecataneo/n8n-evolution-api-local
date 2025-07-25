# Kit de Iniciação Self-hosted: n8n + Evolution API + IA Local

Este é um template Docker Compose de código aberto projetado para inicializar rapidamente um ambiente de desenvolvimento local completo, combinando automação, comunicação via WhatsApp e IA.

Este projeto é uma modificação do incrível [Self-hosted AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit) da equipe do n8n.io, adaptado para incluir a **Evolution API** para integração com o WhatsApp, e simplificado para facilitar a comunicação entre os serviços.

![n8n.io - Screenshot](https://raw.githubusercontent.com/n8n-io/self-hosted-ai-starter-kit/main/assets/n8n-demo.gif)

### O que está incluído?

✅ **[Self-hosted n8n](https://n8n.io/)** - Plataforma low-code com mais de 400 integrações e componentes avançados de IA.

✅ **[Evolution API](https://evolution-api.com/)** - Uma API REST poderosa e estável para interagir com o WhatsApp.

✅ **[Ollama](https://ollama.com/)** - Plataforma para instalar e executar os mais recentes LLMs localmente.

✅ **[Qdrant](https://qdrant.tech/)** - Banco de dados vetorial de alto desempenho para aplicações de IA.

✅ **[PostgreSQL](https://www.postgresql.org/)** - Banco de dados robusto que serve tanto ao n8n quanto à Evolution API.

✅ **[Redis](https://redis.io/)** - Utilizado para o cache da Evolution API, garantindo maior performance.

### O que você pode construir?

⭐️ **Chatbots com IA para WhatsApp** para atendimento ao cliente ou automações pessoais.

⭐️ **Agentes de IA** que agendam compromissos e enviam lembretes via WhatsApp.

⭐️ **Resumir documentos e conversas** de forma segura, sem vazamento de dados.

⭐️ **Integração do WhatsApp com centenas de outras ferramentas** (Slack, Google Sheets, ERPs, etc.) através do n8n.

## A Vantagem: Sem Necessidade de Túnel (ngrok)

Muitos tutoriais para a Evolution API e n8n sugerem o uso de um serviço de túnel como o `ngrok` para expor o webhook do n8n à internet. **Nesta configuração, isso não é necessário.**

Como todos os serviços (n8n, Evolution API, etc.) rodam na mesma rede Docker (`demo`), eles podem se comunicar diretamente usando seus nomes de serviço como se fossem um endereço de rede.

No arquivo `docker-compose.yml`, a Evolution API está configurada para enviar webhooks para `WEBHOOK_GLOBAL_URL=http://n8n:5678/webhook/evolution-webhook`. O Docker se encarrega de direcionar o tráfego do contêiner `evolution-api` para o contêiner `n8n` na porta `5678`, de forma interna, segura e sem nenhuma configuração adicional.

## Instalação

### 1. Clonando o Repositório

```bash
git clone https://github.com/Felipecataneo/n8n-evolution-api-local.git
cd n8n-evolution-api-local
```

### 2. Configurando as Variáveis de Ambiente

Copie o arquivo de exemplo `.env.example` para um novo arquivo chamado `.env`. Você **deve** atualizar os segredos e senhas dentro deste arquivo.

```bash
cp .env.example .env
```

Abra o arquivo `.env` e preencha as senhas e chaves necessárias.

**Arquivo `.env` de exemplo:**
```env
# Postgres - Compartilhado entre N8N e Evolution API
POSTGRES_USER=root
POSTGRES_PASSWORD=insira_uma_senha_forte_aqui
POSTGRES_DB=n8n

# N8N Configuration
N8N_ENCRYPTION_KEY=insira_uma_chave_segura_aqui
N8N_USER_MANAGEMENT_JWT_SECRET=insira_um_segredo_jwt_aqui
WEBHOOK_URL=http://localhost:5678/

# Ollama Configuration
OLLAMA_HOST=ollama:11434

# Evolution API Configuration
EVOLUTION_API_KEY=insira_sua_api_key_aqui
```

### 3. Rodando com Docker Compose

Escolha o perfil que corresponde ao seu hardware.

#### Para usuários de CPU (ou Mac com Apple Silicon)
```bash
docker compose --profile cpu up -d
```

#### Para usuários com GPU Nvidia
*Certifique-se de que os drivers da Nvidia e o [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker) estão instalados.*
```bash
docker compose --profile gpu-nvidia up -d
```

#### Para usuários com GPU AMD (Linux)
```bash
docker compose --profile gpu-amd up -d
```

## ⚡️ Guia de Início Rápido

Após a instalação, siga os passos abaixo para começar a usar:

1.  **Acesse o n8n:** Abra `http://localhost:5678` no seu navegador. Na primeira vez, você precisará configurar uma conta de administrador.

2.  **Acesse a Evolution API:** Abra `http://localhost:9090` para ver a interface do Swagger, onde você pode testar todos os endpoints da API.

3.  **Conecte seu WhatsApp:**
    *   Use uma ferramenta de API (como Insomnia, Postman ou o próprio Swagger) para enviar uma requisição `POST` para `http://localhost:9090/instance/create` para criar uma nova instância.
    *   Em seguida, acesse o endpoint `GET` `http://localhost:9090/instance/connect/{instanceName}` para obter o QRCode. Escaneie-o com seu celular para conectar.

4.  **Crie seu primeiro Workflow no n8n:**
    *   No n8n, crie um novo workflow.
    *   Adicione o nó **Webhook**. Ele irá escutar por eventos da Evolution API.
    *   O n8n mostrará as URLs do webhook. A URL de produção será algo como `http://localhost:5678/webhook/xxxxxxxx-xxxx...`.
    *   A Evolution API já está configurada no `docker-compose.yml` para enviar todos os eventos para o n8n (`http://n8n:5678/webhook/evolution-webhook`). Você pode criar um webhook no n8n que responda neste caminho específico ou usar a URL dinâmica gerada pelo nó.

5.  **Comece a construir!** Agora você pode receber mensagens do WhatsApp no n8n, processá-las com IA usando o Ollama e enviar respostas de volta usando os nós HTTP Request do n8n para chamar a Evolution API.

## Acessando Arquivos Locais

A configuração cria uma pasta compartilhada (`./shared`) que é montada no contêiner do n8n em `/data/shared`. Use este caminho em nós como "Read/Write Files from Disk" para interagir com arquivos no seu sistema local.

## 📜 Licença

Este projeto é licenciado sob a Apache License 2.0 - veja o arquivo `LICENSE` para mais detalhes.

## 💬 Suporte e Créditos

*   **Créditos:** Este trabalho é uma extensão e adaptação do **[n8n Self-hosted AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)**. Agradecimentos à equipe do n8n por fornecer uma base tão sólida.
*   **Suporte:** Para dúvidas, ideias ou para mostrar o que você construiu, junte-se à conversa no [Fórum do n8n](https://community.n8n.io/).