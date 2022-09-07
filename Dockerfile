# Based on nginx alpine image
FROM min17/phpnginx:1.0

# Set workdir to www
WORKDIR /var/www

# Copy laravel files
COPY laravel-app/ .

#install mysql-client
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && apt-get install -y default-mysql-client

# Configure laravel app
RUN php -r "file_exists('.env') || copy('.env.example', '.env');"
RUN composer install
RUN php artisan key:generate
RUN chown -R nobody:nogroup /var/www/storage
RUN chmod -R 777 storage bootstrap/cache

# Define arguments
ARG DB_HOST
ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD

# Set Env Variables
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysqldbinstance.cp480geljvmp.us-east-1.rds.amazonaws.com
ENV DB_PORT=3306
ENV DB_DATABASE=mydb
ENV DB_USERNAME=admin
ENV DB_PASSWORD=1LhRzUXf3AgCAGX4

# clear environment config cache
RUN php artisan config:cache

EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
#CMD ["nginx","-g","daemon off;"]
