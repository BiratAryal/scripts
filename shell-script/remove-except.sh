#!/bin/bash
cd /home/infra_user/delete/
shopt -s extglob
rm -rvf !(jars)
sleep 5
shopt -u extglob
#for using as cron job use following syntax
#*/5 * * * * /bin/bash -c /path/of/script.sh
