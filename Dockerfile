FROM webdevops/php-nginx:8.2

COPY . /app
RUN chmod +x /app/start.sh
CMD ["/app/start.sh"]
