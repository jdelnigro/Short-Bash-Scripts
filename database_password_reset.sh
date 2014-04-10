#! /bin/bash

user=admin

password_reset ()
{
    
output1="wrong"
output2="wrong"
error=$1

while [ $output1 = "wrong" ]; do
    password1=$(zenity --entry \
    --title="Password Reset" \
    --text="${error}" \
    --entry-text "" \
    --hide-text)
    stop=$?
    if [ $stop -ne 0 ];then exit $stop;fi
    if [ "$password1" = "" ];then 
      error="Password can not be blank! \n Enter the new password:" 
      output1="wrong"
      else 
      output1="right"
    fi
done

error="Re-enter the new password:"

while [ $output2 = "wrong" ]; do
    password2=$(zenity --entry \
    --title="Re-enter password:" \
    --text="${error}" \
    --entry-text "" \
    --hide-text)
    stop=$?
    if [ $stop -ne 0 ];then exit $stop;fi
    if [ "$password2" = "" ];then 
      error="Password can not be blank! \n Re-enter the new password:" 
      output2="wrong"
      else 
      output2="right"
    fi
done

return 0

}

ans=$(zenity --list --text "Select account function " --checklist  --column "Pick" --column "Action" FALSE "Reset Password" FALSE "Unlock Account" --separator="\n");
DECIDE=$?
echo "$ans" > /tmp/output
if [ $DECIDE = 0 ];then
cat /tmp/output
while read line;do
	case "$line" in
	"Reset Password")
		password1=0
        password2=1
        stop=0
        error="Enter the new password:"
        while [ ${password1} != ${password2} ] ;do
            password_reset "$error"
            error="Passwords do not match! \n Enter the new password:"
        done
        
        sqlplus "/ as sysdba" << EOF 
alter user $user identified by $password1;
commit;
EOF

	;;
	"Unlock Account")

        sqlplus "/ as sysdba" << EOF 
alter user $user account unlock;
commit;
EOF

	;;
	esac
done < /tmp/output
fi
rm /tmp/output
exit 0
