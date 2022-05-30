#!/bin/bash
# script to init a symfony 2 project

php composer.phar install;

echo "now you need to grant access to database";
# copy template for parameters
cp app/config/parameters.yml.dist app/config/parameters.yml
cat app/config/parameters.yml
# build dedicated database in mysql
# test if database exists
# create database
# test for user
# create user
# ok mysql done

# update schema
php app/console doctrine:schema:update --force 

# clear cache
php app/console cache:clear

# run server
php app/console server:run
