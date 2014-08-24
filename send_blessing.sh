#!/bin/bash
#
# Send blessings subroutine
#
# send_blessings.sh $Name $AGE $DELAY $Carrier $PhoneNumber $COUNT
#

#
# Handle insufficient paramters
#
SyntaxError() {
  echo ""
  echo "ERROR, insufficient parameters given."
  echo ""
  echo "Syntax: send_blessings.sh <Name> <age> <time between messages> <domain of carrier address> <Cellphone number> <Number of messages to send>"
  echo ""
  exit
}


#
#get paramters
#
if [ -z "$1" ]; then
  SyntaxError
else
  Name="$1"
fi
if [ -z "$2" ]; then
  SyntaxError
else
  AGE="$2"
fi
if [ -z "$3" ]; then
  SyntaxError
else
  DELAY="$3"
fi
if [ -z "$4" ]; then
  SyntaxError
else
  Domain="$4"
fi
if [ -z "$5" ]; then
  SyntaxError
else
  PNumber="$5"
fi
if [ -z "$6" ]; then
  SyntaxError
else
  #
  # COUNT should = AGE, if not it means we ran out of blessings.
  #
  COUNT="$6"
fi


#
#Local Variables
#
FROM="Crazy Jew"
I=1
TMPDIR="$Home/BDay"

#
#Loop to send emails to email->text gateways
#
while [ $I -le $COUNT ]; do
        mail -r "${FROM}" -s "Birthday Blessings for ${Name}" $PNumber@$Domain < $TMPDIR/$Name.blessing.$I.txt 
        sleep $DELAY
        rm $TMPDIR/$Name.blessing.$I.txt
        I=$(($I+1))
done

exit 0
