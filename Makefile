# ====================================================================================
# Makefile para Ambiente de Desenvolvimento Laravel com Docker
#
# Autor: Adaptado por Gemini
# Versão: 1.1
# Baseado no excelente modelo fornecido pelo usuário.
# ====================================================================================

# Define o alvo padrão que será executado se você rodar apenas "make"
.DEFAULT_GOAL := help

# --- Variáveis de Configuração ---
# Define o comando base para executar ações dentro do contêiner da aplicação.
# Usamos "-u www-data" para garantir que os comandos rodem com o usuário correto
# do servidor web, evitando problemas de permissão de arquivos.
EXEC_APP   := docker compose exec -u www-data app
ARTISAN    := php artisan
COMPOSER   := $(EXEC_APP) composer

# --- Alvos do Makefile ---
# A diretiva .PHONY garante que estes alvos sempre rodem como comandos,
# mesmo que exista um arquivo com o mesmo nome no diretório.
.PHONY: help setup build up down restart logs shell composer artisan test migrate fresh seed permissions

##@ Gestão do Ambiente
setup: build up permissions composer-install key-generate migrate seed ## [SETUP] Executa o setup completo do ambiente pela primeira vez.
	@echo "\n-> Ambiente configurado com sucesso!"
	@echo "-> Acesse sua aplicação em http://localhost:8000"

build: ## Constrói (ou reconstrói) as imagens Docker.
	@echo "-> Construindo imagens Docker..."
	@docker compose build

up: ## Inicia os contêineres em modo background (detached).
	@echo "-> Iniciando contêineres..."
	@docker compose up -d

down: ## Para e remove os contêineres, redes e volumes anônimos.
	@echo "-> Parando e removendo contêineres..."
	@docker compose down

restart: ## Reinicia todos os serviços definidos no docker-compose.yml.
	@echo "-> Reiniciando contêineres..."
	@docker compose restart

##@ Comandos da Aplicação
composer: ## Executa um comando Composer. Ex: make composer cmd="require laravel/dusk"
	@echo "-> Executando: composer $(cmd)"
	@$(COMPOSER) $(cmd)

composer-install: ## Instala as dependências do Composer a partir do composer.lock.
	@echo "-> Instalando dependências do Composer..."
	@$(COMPOSER) install --no-interaction --prefer-dist --optimize-autoloader

artisan: ## Executa um comando Artisan. Ex: make artisan cmd="queue:work"
	@echo "-> Executando: php artisan $(cmd)"
	@$(ARTISAN) $(cmd)

key-generate: ## Gera a chave da aplicação Laravel (APP_KEY).
	@echo "-> Gerando a chave da aplicação..."
	@$(ARTISAN) key:generate

test: ## Executa o conjunto de testes da aplicação (PHPUnit).
	@echo "-> Executando testes..."
	@$(ARTISAN) test

##@ Banco de Dados
migrate: ## Executa as migrações do banco de dados.
	@echo "-> Executando migrações..."
	@$(ARTISAN) migrate

fresh: ## Apaga todas as tabelas e executa as migrações novamente.
	@echo "-> Recriando o banco de dados do zero..."
	@$(ARTISAN) migrate:fresh

seed: ## Popula o banco de dados com os seeders.
	@echo "-> Populando o banco de dados (seeding)..."
	@$(ARTISAN) db:seed

##@ Utilitários
logs: ## Exibe os logs de todos os serviços em tempo real.
	@echo "-> Exibindo logs... (Pressione Ctrl+C para sair)"
	@docker compose logs -f

shell: ## Acessa o terminal (bash) do contêiner da aplicação.
	@echo "-> Acessando o terminal do contêiner 'app'..."
	@docker compose exec -u www-data app bash

permissions: ## Corrige as permissões (executado como root no contêiner).
	@echo "-> Corrigindo propriedade dos arquivos para 'www-data' (como root)..."
	@docker compose exec app chown -R www-data:www-data storage bootstrap/cache
	@echo "-> Propriedade dos arquivos corrigida com sucesso."

##@ Ajuda
help: ## Mostra esta mensagem de ajuda.
	@echo "Makefile do Projeto Laravel - Comandos Disponíveis:"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / { \
		if ($$1 ~ /^##@/) { \
			printf "\n\033[1;33m%s\033[0m\n", substr($$1, 5); \
		} else { \
			printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2; \
		} \
	}' $(MAKEFILE_LIST)
	@echo ""