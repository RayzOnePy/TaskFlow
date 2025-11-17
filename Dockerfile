FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    libpq-dev

RUN docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY composer.json composer.lock* ./

# Копируем проект с правами www-data
COPY --chown=www-data:www-data . /var/www

RUN composer install --no-dev --optimize-autoloader

RUN npm install

RUN npm run build

EXPOSE 9000

# Запускаем от имени www-data
USER www-data

CMD ["php-fpm"]
