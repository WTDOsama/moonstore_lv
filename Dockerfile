FROM php:8.2-apache

# 1. system + PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# 2. Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 3. copy whole project
COPY . /var/www/html
WORKDIR /var/www/html

# 4. install vendors & cache
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction \
 && composer dump-autoload --optimize

# 5. point Apache to Laravel public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# 6. Render port
ENV APACHE_RUN_PORT=10000
EXPOSE 10000

# 7. start Apache
CMD ["apache2-foreground"]
