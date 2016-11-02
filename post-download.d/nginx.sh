#!/bin/bash

BASE=$1

if [ "$(find "$BASE"/cert-*/* -mmin -1440 | wc -l)" -gt 0 ]; then
    /etc/init.d/nginx reload
fi

