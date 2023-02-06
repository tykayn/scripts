#!/bin/bash


borg create -C zlib,9 /home/tykayn/backup/borgbackup_peertube::peertube_prod_-{now:%Y-%m-%dT%H:%M:%S.%f} /var/www
