#!/bin/sh

rm -rf vendor composer.lock \
&& composer install \
&& php artisan key:generate \
&& php artisan migrate \
&& php artisan db:seed \
&& php artisan l5-swagger:generate \
&& php artisan storage:link \
&& php-fpm
