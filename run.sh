#!/bin/bash

# See if volume needs initializing
/volume-init.sh

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

source /etc/apache2/envvars

echo "restoring database"
mysql -h $DB_HOST -u $DB_NAME -p$DB_PASSWORD wordpress < /database/$(ls -rt /database/ | tail -1)

exec apache2 -D FOREGROUND

