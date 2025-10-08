#!/bin/bash
cd /app
composer install --no-dev
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

