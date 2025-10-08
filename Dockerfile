FROM richarvey/nginx-php-fpm:3.1.6

ENV WEBROOT=/var/www/html/public
ENV RUN_SCRIPTS=1


COPY nginx.conf /etc/nginx/conf.d/default.conf   

CMD ["/start.sh"]
