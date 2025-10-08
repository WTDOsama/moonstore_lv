FROM richarvey/nginx-php-fpm:3.1.6

ENV WEBROOT=/var/www/html/public
ENV RUN_SCRIPTS=1
CMD ["/start.sh"]
