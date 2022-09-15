#!/usr/bin/env bash

# add composer version 2. this is optional and merely an example of adding custom package into swoole container
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2