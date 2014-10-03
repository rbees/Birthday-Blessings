#!/bin/bash

# Victims file format:
# Name,Current City,Current.State,birthdate(YYYYMMDD),birthtime(HHmmss),M/F,relation,cellcarrier,text-number,salutation,Long,Lat,height,weight,BirthTimezone,BirthCity,BirthState,CurrentTimezone
#

MAPQUESTKEY="Put your mapquest key here"
STORDIR="${HOME}/BDay"
TMPDIR="${HOME}/BDay"
BIN="/bin"

#
#Cleanup any outstanding(old) jobs
#
if [ -e "${TMPDIR}/victims" ]; then
  rm ${TMPDIR}/victims
fi

# Name
echo -n "Enter the victim's name. "
echo -n "First name or Nick name.  No spaces please. >"
read NAME
echo "You entered: $NAME"

# Current Address
# Used to get Longitude and Latitude
echo -n "What is the victim's current street address? ( omit apartment #'s > "
read CSADD
echo "You entered: $CSADD"

# Current City
echo -n "Enter the victim's current City > "
read CCITY
echo "You entered: $CCITY"

# Current State
echo -n "Enter the victim's current State > "
read CSTATE
echo "You entered: $CSTATE"

# Current time zone
echo -n "What timezone does the victim live in?  "
echo -n "These scripts DO NOT adjust for daylight savings time. > "
read CTZONE
echo "You entered: $CTZONE"

# Birthdate
echo -n "Enter the victim's civil birthday (YYYYMMDD) > "
read BDATE
echo "You entered: $BDATE"

# Time of birth
echo -n "Enter the victim's time of birth. (HHmmSS)  If not known leave blank and sundown will be used. "
echo -n "These scripts DO NOT adjust for daylight savings time so if the birth time is close to sundown "
echo -n "you will need to adjust this accordingly. > "
read BTIME
echo "You entered: $BTIME"

# Birth Time Zone
echo -n "What timezone was the victim born in?  "
echo -n "These scripts DO NOT adjust for daylight savings time so if the birth time is close to sundown "
echo -n "you may need to adjust this accordingly. > "
read BTZONE
echo "You entered: $BTZONE"

# Address where victim was born
# Used to establish sundown when the victim was born
echo -n "Street address where the victim was born.  "
echo -n "If not known leave blank. > "
read BSADD
echo "You entered: $BSADD"

# Birth City
echo -n " What city/town was the victim born in? "
echo -n " If not known leave blank and their current address will be used. > "
read BCITY
echo "You entered: $BCITY"

# Birth State
echo -n " What State was the victim born in? "
echo -n " If not known leave blank and their current address will be used. > "
read BSTATE
echo "You entered: $BSTATE"

# Gender
echo -n "Is the victim male or female (m/f)  > "
read GENDER
echo "You entered: $GENDER"

# Relation
echo -n "What is the victim's relationship to you? (spouse, child, parent, friend) > "
read RELATIONSHIP
echo "You entered: $RELATIONSHIP"

# The Recipent's Cell Carrier

echo 'Select your Cell Service:'
PS3='Provider? '
select carrier in \
    'AT&T' \
    'Verizon' \
    'Sprint' \
    'Alltell' \
    'Cingular' \
    'Nextel' \
    'SunCom' \
    'T-Mobile' \
    'Voice Stream' \
    'US Cellullar' \
    'Cricket' \
    'Virgin' \
    'Boost' \
    'Boost Mobile' \
    'Einsteingcs' \
    'Einstien' \
    'Unknown'
    do
    case $REPLY in
        1 ) CCARRIER='att' ;;
        2 ) CCARRIER='verizon' ;;
        3 ) CCARRIER='sprint' ;;
        4 ) CCARRIER='alltel' ;;
        5 ) CCARRIER='cingular' ;;
        6 ) CCARRIER='nextel' ;;
        7 ) CCARRIER='sunCom' ;;
        8 ) CCARRIER='tmobile' ;;
        9 ) CCARRIER='voicestream' ;;
        10 ) CCARRIER='uscellular' ;;
        11 ) CCARRIER='cricket' ;;
        12 ) CCARRIER='virgin' ;;
        13 ) CCARRIER='boostmobile|boost' ;;
        14 ) CCARRIER='boostmobile|boost' ;;
        15 ) CCARRIER='einsteinpcs|einstein' ;;
        16 ) CCARRIER='einsteinpcs|einstein' ;;
        17 ) CCARRIER='unknown' ;;
        * ) echo 'invalid choice.' ;;
    esac

    if [[ -n $carrier ]]; then
        echo "CCARRIER is $CCARRIER"
	  if [[ $CCARRIER == 'unknown' ]]; then
             echo " This script can't use a carrier it does not know. Sorry. "
             echo " You will have to Hack the scripts to add yours. "
             break
          fi
        break
   fi
done



# Cell Number
echo -n "And the victim's phone number. 0001112222 no spaces please "  
echo -n "Note that T-Mobile sometimes requires the long-distance prefix 1 > "
read VNUMBER
echo "You entered: $VNUMBER"

# Salutation
echo -n "How would you like the blessing to start? (Default: Blessed is HaShem our G0D the King of the Universe who.... > "
echo -n "Currently this has no effect on the blessings.  I will not object to someone fixing that issue. ;)"
read SALU
echo "You entered: $SALU"

# Height
echo -n "Is the victim tall, short, or average? (t/s/a) > "
read VHIGHT
echo "You entered: $VHIGHT"

# Weight
echo -n "Is the skinny, stocky, or average? (sk/st/a) > "
read VSIZE
echo "You entered: $VSIZE"

# Birth site Longitude & Latitude

#Geolocation to calculate sunup/sundown
# BigData= `wget "http://www.mapquestapi.com/geocoding/v1/address?key=$MAPQUEST_API_KEY&outFormat=csv&city=Kalkaska&state=MI" -O -`
#
#returns:
#
#"Country","State","County","City","PostalCode","Street","Lat","Lng","DragPoint","LinkId","Type","GeocodeQualityCode","GeocodeQuality","SideOfStreet","DisplayLat","DisplayLng" "US","MI","Kalkaska County","Kalkaska","","","44.733364","-85.172346","false","282032575","s","A5XAX","CITY","N","44.733364","-85.172346"
#

# BirthGEOLOCAL=`wget -q "http://www.mapquestapi.com/geocoding/v1/address?key=${MAPQUESTKEY}&outFormat=csv& street=${BSADD}&city=${BCITY}&state=${BSTATE}" -O -`

# BLocData=`echo ${GEOLOCAL} | awk -F"\" \"" '{printf("%s",$2)}'`
#         BLNG=`echo ${BLocData} | awk -F"," '{printf("%s",$7)}' | sed s/\"//g`
#         BLAT=`echo ${BLocData} | awk -F"," '{printf("%s",$8)}' | sed s/\"//g`


# Current Longitude & Latitude
GEOLOCAL=`wget -q "http://www.mapquestapi.com/geocoding/v1/address?key=${MAPQUESTKEY}&outFormat=csv& street=${CSADD}&city=${CCITY}&state=${CSTATE}" -O -`
#echo $GEOLOCAL

BLocData=`echo ${GEOLOCAL} | awk -F"\" \"" '{printf("%s",$2)}'`
        CLNG=`echo ${BLocData} | awk -F"," '{printf("%s",$7)}' | sed s/\"//g`
        CLAT=`echo ${BLocData} | awk -F"," '{printf("%s",$8)}' | sed s/\"//g`

set -x
# Generate victims file
echo "${NAME},${CCITY},${CSTATE},${BDATE},${BTIME},${GENDER},${RELATIONSHIP},${CCARRIER},${VNUMBER},${SALU},${CLNG},${CLAT},${VHIGHT},${VSIZE},${BTZONE},${BCITY},${BSTATE},${CTZONE}" >> ${STORDIR}/victims

echo -n "The victims file has been generated. "
echo -n "Run bless_victims.sh to generate the series of blessing to send to the victim."

exit 0