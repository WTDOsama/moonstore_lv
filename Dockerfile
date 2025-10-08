FROM php:8.2-cli

# system tools + extensions
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# copy whole project into /app
COPY . /app
WORKDIR /app

# install deps & cache
RUN composer install --no-dev --optimize-autoloader
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# expose Render port
EXPOSE 10000

# start Laravel dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
