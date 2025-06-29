# 🚀 Laravel Backend API

Sistema backend desenvolvido em Laravel com PHP 8.3, PostgreSQL e Docker para containerização.

## 📋 Índice

- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Uso](#uso)
- [Desenvolvimento](#desenvolvimento)
- [Testes](#testes)
- [Deploy](#deploy)
- [Comandos Úteis](#comandos-úteis)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Contribuição](#contribuição)

## 🔧 Pré-requisitos

- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Git**
- **Make** (opcional, para comandos facilitados)

### Sem Docker (desenvolvimento local):
- **PHP** >= 8.2
- **Composer** >= 2.0
- **PostgreSQL** >= 13
- **Node.js** >= 18 (para assets)

## 📦 Instalação

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/seu-backend.git
cd seu-backend
```

### 2. Configuração inicial com Docker
```bash
# Usando Make (recomendado)
make setup

# Ou manualmente
docker-compose build
docker-compose up -d
docker-compose exec app composer install
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed
```

### 3. Configuração sem Docker
```bash
# Instalar dependências
composer install
npm install

# Configurar ambiente
cp .env.example .env
php artisan key:generate

# Configurar banco de dados (veja seção Configuração)
php artisan migrate
php artisan db:seed

# Compilar assets
npm run build
```

## ⚙️ Configuração

### 1. Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e configure:

```env
# Aplicação
APP_NAME="Laravel Backend"
APP_ENV=local
APP_KEY=base64:SUA_CHAVE_AQUI
APP_DEBUG=true
APP_URL=http://localhost:8000

# Banco de Dados
DB_CONNECTION=pgsql
DB_HOST=db                    # 'localhost' se não usar Docker
DB_PORT=5432
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password

# Cache
CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

# Redis
REDIS_HOST=redis              # 'localhost' se não usar Docker
REDIS_PASSWORD=null
REDIS_PORT=6379

# Email
MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

# JWT (se usar autenticação)
JWT_SECRET=sua_chave_jwt_aqui

# APIs Externas
FRONTEND_URL=http://localhost:3000
```

### 2. Configuração do Banco de Dados

#### Com Docker:
O PostgreSQL será configurado automaticamente via Docker Compose.

#### Sem Docker:
```bash
# Criar banco de dados
createdb laravel_db

# Ou via psql
psql -U postgres
CREATE DATABASE laravel_db;
CREATE USER laravel_user WITH PASSWORD 'laravel_password';
GRANT ALL PRIVILEGES ON DATABASE laravel_db TO laravel_user;
```

### 3. Configuração de Permissões
```bash
# Com Docker
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R www:www storage bootstrap/cache

# Sem Docker
chmod -R 775 storage bootstrap/cache
```

## 🔥 Uso

### Iniciar Desenvolvimento

#### Com Docker:
```bash
# Iniciar todos os serviços
make up
# ou
docker-compose up -d

# Verificar logs
make logs
# ou
docker-compose logs -f
```

#### Sem Docker:
```bash
# Iniciar servidor
php artisan serve --host=0.0.0.0 --port=8000

# Iniciar queue worker (em outro terminal)
php artisan queue:work

# Iniciar scheduler (em outro terminal)
php artisan schedule:work
```

### Acessos

- **API**: http://localhost:8000
- **Documentação**: http://localhost:8000/docs (se configurado)
- **PostgreSQL**: localhost:5432
- **Adminer** (se configurado): http://localhost:8080

## 🛠️ Desenvolvimento

### Estrutura de Pastas
```
app/
├── Console/           # Comandos Artisan
├── Exceptions/        # Tratamento de exceções
├── Http/
│   ├── Controllers/   # Controladores da API
│   ├── Middleware/    # Middleware customizado
│   ├── Requests/      # Form Requests
│   └── Resources/     # API Resources
├── Models/            # Modelos Eloquent
├── Providers/         # Service Providers
└── Services/          # Services/Business Logic

database/
├── factories/         # Model Factories
├── migrations/        # Migrations
└── seeders/          # Database Seeders

routes/
├── api.php           # Rotas da API
└── web.php           # Rotas web
```

### Comandos de Desenvolvimento

```bash
# Criar controller
php artisan make:controller Api/UserController --api

# Criar model com migration
php artisan make:model User -m

# Criar request
php artisan make:request StoreUserRequest

# Criar resource
php artisan make:resource UserResource

# Criar service
php artisan make:service UserService

# Criar job
php artisan make:job ProcessUserData

# Criar middleware
php artisan make:middleware CheckApiKey
```

### Executar Migrations
```bash
# Com Docker
make migrate
# ou
docker-compose exec app php artisan migrate

# Sem Docker
php artisan migrate
```

### Executar Seeders
```bash
# Com Docker
make seed
# ou
docker-compose exec app php artisan db:seed

# Sem Docker
php artisan db:seed
```

## 🧪 Testes

### Configuração de Testes

Crie um arquivo `.env.testing`:
```env
APP_ENV=testing
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=laravel_test
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password
```

### Executar Testes

```bash
# Com Docker
make test
# ou
docker-compose exec app php artisan test

# Sem Docker
php artisan test

# Com cobertura
php artisan test --coverage

# Testes específicos
php artisan test --filter UserTest
```

### Tipos de Testes

- **Unit Tests**: `tests/Unit/`
- **Feature Tests**: `tests/Feature/`
- **Integration Tests**: `tests/Integration/`

## 🚀 Deploy

### Usando GitHub Actions

O projeto inclui workflow automatizado. Configure os secrets:

```
DOCKER_USERNAME=seu_usuario_docker
DOCKER_PASSWORD=sua_senha_docker
HOST=ip_do_servidor
USERNAME=usuario_ssh
SSH_KEY=chave_privada_ssh
PORT=22
PROJECT_PATH=/var/www/backend
```

### Deploy Manual

```bash
# No servidor
git pull origin main
docker-compose pull
docker-compose down
docker-compose up -d
docker-compose exec app php artisan migrate --force
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache
```

## 📝 Comandos Úteis

### Makefile
```bash
make help           # Mostrar ajuda
make build          # Construir imagens
make up             # Iniciar containers
make down           # Parar containers
make restart        # Reiniciar containers
make logs           # Mostrar logs
make shell          # Acessar shell do container
make composer       # Instalar dependências
make migrate        # Executar migrations
make fresh          # Recrear banco
make seed           # Executar seeders
make test           # Executar testes
```

### Artisan Commands
```bash
# Cache
php artisan cache:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Queue
php artisan queue:work
php artisan queue:restart
php artisan queue:failed

# Maintenance
php artisan down
php artisan up

# Tinker (REPL)
php artisan tinker
```

## 📁 Estrutura do Projeto

```
backend/
├── app/                    # Código da aplicação
├── bootstrap/              # Bootstrap da aplicação
├── config/                 # Arquivos de configuração
├── database/               # Migrations, seeds, factories
├── public/                 # Arquivos públicos
├── resources/              # Views, assets
├── routes/                 # Definição de rotas
├── storage/                # Arquivos de storage
├── tests/                  # Testes automatizados
├── docker/                 # Configurações Docker
│   ├── nginx/
│   ├── php/
│   └── postgres/
├── .env.example           # Exemplo de variáveis de ambiente
├── .gitignore             # Arquivos ignorados pelo Git
├── composer.json          # Dependências PHP
├── docker-compose.yml     # Configuração Docker
├── Dockerfile             # Imagem Docker
├── Makefile              # Comandos facilitados
└── README.md             # Este arquivo
```

## 🔐 Segurança

### Boas Práticas Implementadas

- ✅ Validação de entrada com Form Requests
- ✅ Sanitização de dados
- ✅ Rate limiting
- ✅ CORS configurado
- ✅ Logs de segurança
- ✅ Hash de senhas com bcrypt
- ✅ Middleware de autenticação
- ✅ Validação CSRF

### Configurações Importantes

```php
// config/app.php
'debug' => env('APP_DEBUG', false),

// config/cors.php
'allowed_origins' => [env('FRONTEND_URL', 'http://localhost:3000')],
```

## 🤝 Contribuição

### Padrões de Código

- **PSR-4** para autoloading
- **PSR-12** para style guide
- **PHPDoc** para documentação
- **Conventional Commits** para mensagens

### Fluxo de Contribuição

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'feat: adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

### Executar Análise de Código

```bash
# PHP CS Fixer
vendor/bin/php-cs-fixer fix

# PHPStan
vendor/bin/phpstan analyse

# Audit de segurança
composer audit
```

## 📞 Suporte

- **Documentação**: [Laravel Docs](https://laravel.com/docs)
- **Issues**: [GitHub Issues](https://github.com/seu-usuario/seu-backend/issues)
- **Email**: seu-email@dominio.com

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Desenvolvido com ❤️ usando Laravel**