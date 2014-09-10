#!/bin/bash
#
#Geolocation to calculate sunup/sundown
# BigData= `wget "http://www.mapquestapi.com/geocoding/v1/address?key=$MAPQUEST_API_KEY&outFormat=csv&city=Kalkaska&state=MI" -O -`
#
#returns:
#
#"Country","State","County","City","PostalCode","Street","Lat","Lng","DragPoint","LinkId","Type","GeocodeQualityCode","GeocodeQuality","SideOfStreet","DisplayLat","DisplayLng" "US","MI","Kalkaska County","Kalkaska","","","44.733364","-85.172346","false","282032575","s","A5XAX","CITY","N","44.733364","-85.172346"
#
#


#Data files:
# Victims file format:
#   Name,CurrentCity,CurrentState,birthdate(YYYYMMDD),birthtime(HHmmss),M/F,relation,cellcarrier,text-number,salutation,Long,Lat,height,weight,BirthTimezone,BirthCity,BirthState,CurrentTimezone
#
# Examples:
#   John,Detroit,MI,19780127,040500,M,other,att,6165550101,Mr,99.9999,99.9999,tall,slender,-5,Laramie,WY,-7
#   Jane,Cadillac,MI,19780507.013000,F,spouse,att,2315550001,Mrs,99.9999,99.9999,short,plump,-5,Salt Lake City,UT,-7
#   Frederick,Gaylord,MI,20000828,010000,M,other,verizon,2315555410,Mr,,,,,-5,Gaylord,MI,-5
#

# You need to get your own mapquest key from
# http://developer.mapquest.com/web/products/dev-services/geocoding-ws
# and place it in the MAPQUESTKEY variable below on line 40

#
# Current date and other constants
#
TYEAR=`date +%Y`
TMONTH=`date +%m`
TDAY=`date +%d`
STZONE=`date +%:::z`
#if your system is using UTC and you aren't in UTC's timezone, then you should specify your timzone below, after uncommenting the line out.
#STZONE="-05"

TODAY="${TDAY} ${TMONTH} ${TYEAR} ${TZONE}"
TotalDayMinutes=1440

MAPQUESTKEY="Put your mapquest key here"
STORDIR="${HOME}/BDay"
BINDIR="${HOME}/BDay"
TMPDIR="${HOME}/BDay"
BIN="/bin"

#
#Cleanup any outstanding(old) jobs
#
if [ -e "${TMPDIR}/myjobs.sh" ]; then
  rm ${TMPDIR}/myjobs.sh
fi

#
# Read in $STORDIR/vicitms file and process it
#
cat ${STORDIR}/victims | while read VICTIM
do
        #
        # if an empty line is found, terminate reading victims file
        #
        if [ "${VICTIM}" == "" ]; then
           break
        fi
        #
        #split victims entry into it's parts
        #
        Name=`echo ${VICTIM} | awk -F"," '{printf("%s",$1)}'`
        echo "- ${Name}"
        City=`echo ${VICTIM} | awk -F"," '{printf("%s",$2)}'`
        State=`echo ${VICTIM} | awk -F"," '{printf("%s",$3)}'`
        BDate=`echo ${VICTIM} | awk -F"," '{printf("%s",$4)}'`
        BTime=`echo ${VICTIM} | awk -F"," '{printf("%s",$5)}'`
        Sex=`echo ${VICTIM} | awk -F"," '{printf("%s",$6)}'`
        case ${Sex} in
         M|m) 
          Sex="man"
          ;;
         F|f)
          Sex="woman"
          ;;
         *)
          Sex="living being"
          ;;
        esac
        Relation=`echo $VICTIM | awk -F"," '{printf("%s",$7)}'`
        Carrier=`echo $VICTIM | awk -F"," '{printf("%s",$8)}'`
        PNumber=`echo $VICTIM | awk -F"," '{printf("%s",$9)}'`
        Salutation=`echo $VICTIM | awk -F"," '{printf("%s",$10)}'`
        Long=`echo $VICTIM | awk -F"," '{printf("%s",$11)}'`
        Lat=`echo $VICTIM | awk -F"," '{printf("%s",$12)}'`
        Height=`echo $VICTIM |awk -F"," '{printf("%s",$13)}'`
        Weight=`echo $VICTIM |awk -F"," '{printf("%s",$14)}'`
        TZone=`echo $VICTIM |awk -F"," '{printf("%s",$15)}'`
        BCity=`echo $VICTIM |awk -F"," '{printf("%s",$16)}'`
        BState=`echo $VICTIM |awk -F"," '{printf("%s",$17)}'`
        BTZone=`echo $VICTIM |awk -F"," '{printf("%s",$18)}'`
        if [ "$BCity" == "" ]; then
          BCity="$City"
          BState="$State"
          BTZone="$TZone"
        fi
        BYear=`echo ${BDate:0:4}`
        BMonth=`echo ${BDate:4:2}`
        BDay=`echo ${BDate:6:2}`
        if [ "${BMonth:0:1}" = "0" ]; then
          BMonth=`echo ${BMonth:1,1}`
        fi
        AGE=$(($((${TYEAR}))-$((${BYear}))))

<<<<<<< HEAD
        #
=======
	#
>>>>>>> c54693a518d1a600268cbe3c53cb32d662b40244
        # processing carrier
        #
        case $Carrier in
         att) 
           Domain="mms.att.net"
           ;;
         verizon)
           Domain="vtext.com"
           ;;
         sprint)
           Domain="messaging.sprintpcs.com"
           ;;
         alltel)
           Domain="message.alltel.com"
           ;;
         cingular)
           Domain="mobile.mycingular.com"
           ;;
         nextel)
           Domain="messaging.nextel.com"
           ;;
         sunCom)
           Domain="tms.suncom.com"
           ;;
         tmobile)
           Domain="tmomail.net"
           ;;
         voicestream)
           Domain="voicestream.net"
           ;;
         uscellular)
           Domain="email.uscc.net"
           ;;
         cricket)
           Domain="mms.mycricket.com"
           ;;
         virgin)
           Domain="vmobl.com"
           ;;
         boostmobile|boost)
           Domain="myboostmobile.com"
           ;;
         einsteinpcs|einstein)
           Domain="einsteinmms.com"
           ;;
         *)
           Domain="unknown..."
           echo "Unable to send blessings.  Unknown Cellular carrier."
           exit
           ;;
        esac

        #
        #get location data for Birth location and Current location
        #
        BData=`wget -q "http://www.mapquestapi.com/geocoding/v1/address?key=${MAPQUESTKEY}&outFormat=csv&city=$BCity&state=$BState" -O -`
        CData=`wget -q "http://www.mapquestapi.com/geocoding/v1/address?key=${MAPQUESTKEY}&outFormat=csv&city=$City&state=$State" -O -`

        BLocData=`echo $BData | awk -F"\" \"" '{printf("%s",$2)}'`
        BLong=`echo $BLocData | awk -F"," '{printf("%s",$7)}' | sed s/\"//g`
        BLati=`echo $BLocData | awk -F"," '{printf("%s",$8)}' | sed s/\"//g`

        CLocData=`echo $CData | awk -F"\" \"" '{printf("%s",$2)}'`
        CLong=`echo $CLocData | awk -F"," '{printf("%s",$7)}' | sed s/\"//g`
        CLati=`echo $CLocData | awk -F"," '{printf("%s",$8)}' | sed s/\"//g`

        #
        #Calculate Hebrew Dates/times
        #
        BHDate=`hdate -qTts -l $BLong -L $BLati -z $BTZone $BDay $BMonth $BYear`

        BHSunset=`echo $BHDATE | awk -F"," '{printf("%s",$7)}'`
        BHSHour="${BHSunset:0:2}"
        BHSMin="${BHSunset:2:2}"
        BTHour="${BTime:0:2}"
        BTMin="${BTime:2:2}"

        if [ "${BTHour}" == "${BHSHour}" ]; then
           if [ ${BHSMin} < ${BTMin}  ];then
              BDay=$(($(($BDay))+1))
              BHDate=`hdate -qTs -l ${BLong} -L ${BLati} -z ${BTZone} ${BDay} ${BMonth} ${BYear}`
           fi
        else
           if [ $((${BHSHour})) -le $((${BTHour})) ]; then
              BDay=$(($(($BDay))+1))
              BHDate=`hdate -iqTts -l ${BLong} -L ${BLati} -z ${BTZone} ${BDay} ${BMonth} ${BYear}`
           fi
        fi

        CHDate=`hdate -qTts -l ${CLong} -L ${CLati} -z ${TZone}`
        CHDSunset=`echo ${CHDate} | awk -F"," '{printf("%s",$16)}'`
        CHDSHour="${CHDSunset:0:2}"
        CHDSMin="${CHDSunset:3:2}"

        #Number of times to send blessing, based on age
        Count="$AGE"
        Delay=$((60*$(($(($TotalDayMinutes))/$(($AGE))))))

        #Processing loop
        #
        #Processing loop to generate blessings
        #
        I=0
        COUNT=0
        while [ $I -lt $Count ]; do
                #for now, assumes all blessings are generic.  No M/F, Age, or relational component branches
                I=$(($I+1))
                #
                #Get Blessing from Blessings file
                #
                
                BlText=`grep -e "^$I|" ${STORDIR}/Blessings.txt`
                if [ "$BlText" == "" ]; then
                  BlText="999||You have lived so long that you have already received every blessing humanly possible.  It is time to share that blessing and your wisdom with the world."
                  COUNT=$I
                  I=999
                fi
                #
                #Convert variables in the blessings to values
                #
                Blessing=`echo ${BlText//@AGE@/$AGE}`
                Blessing=`echo ${Blessing//@NAME@/$Name}`
                Blessing=`echo ${Blessing//@SEX@/$Sex}`

                #  Column 1 is the plessing ID, Column 2 is for any flags for decision making, Column 3 is the acutal blessing.  
                Blessing=`echo ${Blessing} | awk -F"|" '{printf("%s",$3)}'`

                #
                #Store blessing to be sent in temporary file
                #
                echo "${Blessing}" > $TMPDIR/$Name.blessing.$I.txt
        done
        if [ "$COUNT" == "0" ]; then
           COUNT=$AGE
        fi
        #
        #create job file
        #
        echo "$BIN/bash $BINDIR/send_blessings.sh $Name $AGE $Delay $Domain $PNumber $COUNT &" >> $TMPDIR/myjobs.sh
done

echo ""
echo "Processing done.  Run $TMPDIR/myjobs.sh at sundown to send them."
echo ""
exit 0
