# Use a imagem oficial do PHP 8.3 FPM
FROM php:8.3-fpm

# Defina o diretório de trabalho
WORKDIR /var/www/html

ARG UID=1000
ARG GID=1000

# Instale as dependências do sistema e as extensões do PHP
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    # Adicione a biblioteca cliente do PostgreSQL
    libpq-dev \
    && docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd zip

RUN groupadd -o -g ${GID} laravel || true && \
    useradd  -o -u ${UID} -g laravel -m -s /bin/bash laravel || true

# Instale o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copie os arquivos da aplicação
COPY . .

# Defina as permissões para o diretório de armazenamento
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
COPY --chown=laravel:laravel . .


USER laravel

# Exponha a porta 9000 para o PHP-FPM
EXPOSE 9000

# Comando para iniciar o PHP-FPM
CMD ["php-fpm"]