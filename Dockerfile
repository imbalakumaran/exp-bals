FROM php:8.1-cli

RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev curl \
    && docker-php-ext-install pdo pdo_mysql

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

WORKDIR /app

COPY . .

# PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Frontend dependencies
RUN npm install
RUN npm run build

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=8000
