#!/bin/bash

# Prerequisites
# 1. Determine which shell you are using.
# 2. Adding date and time on ~/.bash_profile
# 3. Adding ip associated with the user.
# 4. Reload bash_profile by using source ~/.bash_profile

# USER_IP='who -u am i 2>/dev/null| awk '{print $1,$NF}''
echo -e "*****************************************************************************************************\n $(date +%d/%m/%Y) \n*****************************************************************************************************\n"
# last -n 5| grep test | xargs| awk '{print $1,$2,$3,$4}';
history | cut -d " " -f5-9 >> ssh-history.log;
history -c;
