#!/bin/bash

# Send blessings subroutine
# send_blessings.sh $NAME $AGE $DELAY $CARRIER $PHONE_NUMBER $COUNT

# Handle insufficient paramters
SyntaxError() {
    printf "ERROR, insufficient parameters given.\n\n"
    printf "Syntax: send_blessings.sh <Name> <age> <time between messages> <domain of carrier address> <Cellphone number>"
    exit 0
}


# Get Parameters
if [[ "$#" -ne 5 ]]
then
    SyntaxError
fi

NAME=$1
AGE=$2
DELAY=$3
DOMAIN=$4
PHONE_NUMBER=$5


# Local Variables
FROM="Crazy Jew"
TMPDIR="$HOME/BDay"

# Loop to send emails to email->text gateways
i=0
while [ $i -lt $AGE ]; do
    mail -s "${NAME}'n Birthday Blessing from ${FROM}" $PHONE_NUMBER@$DOMAIN < $TMPDIR/$NAME.blessing.$i.txt 
    sleep $DELAY
    rm $TMPDIR/$NAME.blessing.$i.txt
    i=$[$i+1]
done

exit 0
