FROM webdevops/php-nginx:8.2-alpine

# install system deps + PHP extensions
RUN apk add --no-cache git unzip \
    && docker-php-ext-install pdo pdo_mysql gd

COPY . /app
WORKDIR /app

# composer with retry + no scripts at build time
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

EXPOSE 10000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
