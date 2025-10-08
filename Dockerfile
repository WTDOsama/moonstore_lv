FROM php:8.2-cli

# 1. system deps
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# 2. Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 3. copy code
COPY . /app
WORKDIR /app

# 4. install dependencies (no scripts, no dev)
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction \
 && composer dump-autoload --optimize

# 5. Laravel caches (run at start-up, not build)
# 6. expose Render port
EXPOSE 10000

# 7. start Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
