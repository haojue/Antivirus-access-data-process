#! /bin/bash
DATE=`date -d -2days '+%F'`
FILE=${DATE}_uniq_2
DATE1=`date -d -2days '+%d/%b/%Y'`
FILE1=$DATE
# echo "$DATE" 
#mkdir $DATE
#cp $FILE1 $DATE/
./ftp_utm.exp 10.208.3.47 aaa aaa
7za e utm_aaaa.bin
7za e utm_bbbb.bin
cat utm_aaaa > $FILE1                                                                                                                                   
cat utm_bbbb >> $FILE1
echo "Generate file for $DATE\n"
grep  "$DATE1" $FILE1  > ${DATE}_uniq
touch $FILE
echo "Delete redundant access entry for $DATE\n"
./ipuniq.pl ${DATE}_uniq $FILE
rm -f utm_aaaa* utm_bbbb*
#foo () {
echo "$DATE" >> ip_stats.txt 
echo "$DATE" >> stats.txt

#################################################
# Add KAV,EAV,SAV,KAV_engine INFO in ip_stats.txt
#################################################

touch  KAV_"$DATE".ip.occur 
echo > KAV_"$DATE".ip.occur
for platform in SRX100 SRX110 SRX210 SRX220 SRX240 SRX550 SRX650; do
grep "AV/$platform" $FILE | grep -v "EAV" | grep -v "SAV" | awk {'print $1'} > KAV_"$platform"_"$DATE".ipraw
./ipuniq.pl KAV_"$platform"_"$DATE".ipraw KAV_"$platform"_"$DATE".ip.occur
COUNT=`cat KAV_"$platform"_"$DATE".ip.occur | wc -l` 
echo "KAV $platform $COUNT" >> ip_stats.txt
cat KAV_"$platform"_"$DATE".ip.occur >>  KAV_"$DATE".ip.occur 
done 

touch EAV_"$DATE".ip.occur
echo > EAV_"$DATE".ip.occur
for platform in SRX210 SRX220 SRX240 SRX550 SRX650; do
grep "EAV/$platform" $FILE | awk {'print $1'} > EAV_"$platform"_"$DATE".ipraw
./ipuniq.pl EAV_"$platform"_"$DATE".ipraw EAV_"$platform"_"$DATE".ip.occur
COUNT=`cat EAV_"$platform"_"$DATE".ip.occur | wc -l`
echo "EAV $platform $COUNT" >> ip_stats.txt
cat EAV_"$platform"_"$DATE".ip.occur >>  EAV_"$DATE".ip.occur
done


touch SAV_"$DATE".ip.occur
echo >  SAV_"$DATE".ip.occur
grep  "SAV" $FILE | awk {'print $1'} > SAV_"$DATE".ipraw
./ipuniq.pl SAV_"$DATE".ipraw SAV_"$DATE".ip.occur
COUNT=`cat SAV_"$DATE".ip.occur | wc -l`
echo "SAV N/A $COUNT" >> ip_stats.txt

touch KAV_engine_"$DATE".ip.occur
echo > KAV_engine_"$DATE".ip.occur
for platform in i386 octeon32; do
grep  "KAV_engine/$platform/kav-worker" $FILE | awk {'print $1'} > KAV_engine_"$platform"_"$DATE".ipraw
./ipuniq.pl KAV_engine_"$platform"_"$DATE".ipraw KAV_engine_"$platform"_"$DATE".ip.occur
COUNT=`cat KAV_engine_"$platform"_"$DATE".ip.occur | wc -l`
echo "KAV_engine $platform $COUNT" >> ip_stats.txt
cat KAV_engine_"$platform"_"$DATE".ip.occur >> KAV_engine_"$DATE".ip.occur
done

##########################################################       
# Add KAV,EAV,SAV,KAV_engine File access INFO in stats.txt
##########################################################
declare -A arr
arr=(["KAV_engine"]=kav-worker ["KAV"]=dailyc.avc ["EAV"]=qavdb ["SAV"]=vdlversion.txt) 
for key in ${!arr[*]}; do
	if [ $key == "EAV" ]; then
	egrep "GET.*qavdb" $FILE | awk {'print $1'} > EAV_"$DATE".raw
	else 
	grep  "${arr[$key]}" $FILE | awk {'print $1'} > "$key"_"$DATE".raw 
        fi
#./ipuniq.pl "$key"_"$DATE".raw "$key"_"$DATE".occur
#COUNT=`cat "$key"_"$DATE".occur | wc -l`
COUNT=`cat "$key"_"$DATE".raw | wc -l`
echo "$key ${arr[$key]}  $COUNT" >> stats.txt
done

#}
##########################################################
#  Obtain all accessing IP 
##########################################################
#egrep "AV\/"    $FILE | awk {'print $1'} > AV_"$DATE".ipraw
#./ipuniq.pl AV_"$DATE".ipraw AV_"$DATE".ip.occur
#cat AV_"$DATE".ip.occur | awk {'print $1'} > AV_"$DATE".ip
##########################################################
#  Obtain all DNS info for all accessing IP 
##########################################################
echo "Start IP Domain query, may take a long time\n"
start=`date +%s`
######### For multithread DNS query #############
for IPFILE in KAV_"$DATE".ip.occur EAV_"$DATE".ip.occur SAV_"$DATE".ip.occur KAV_engine_"$DATE".ip.occur; do
#for IPFILE in EAV_"$DATE".ip.occur SAV_"$DATE".ip.occur KAV_engine_"$DATE".ip.occur; do
touch ${IPFILE}_domainstats
chmod 777  ${IPFILE}_domainstats
echo > ${IPFILE}_domainstats
LINES=`cat $IPFILE | wc -l`
NUM=`echo "scale=4; $LINES/700" | bc`
#echo "$NUM"
NUM=`echo $((${NUM//.*/+1}))`
#echo "$NUM"
split -l 700 $IPFILE  ${IPFILE}_ -a 1 -d
./ip2domain.pl $IPFILE ${IPFILE}_domainstats $NUM
cat ${IPFILE}_domainstats > /usr/local/apache/htdocs/${IPFILE}_domainstats
done
end=`date +%s`
dif=$[ end - start ]
echo "DNS query time spent $dif s\n"

##########################################################
#  Copy results to apache server directory
##########################################################
#cat KAV_"$DATE".ip.occur >  /usr/local/apache/htdocs/KAV_"$DATE".ip.occur
#cat EAV_"$DATE".ip.occur >  /usr/local/apache/htdocs/EAV_"$DATE".ip.occur
#cat SAV_"$DATE".ip.occur >  /usr/local/apache/htdocs/SAV_"$DATE".ip.occur
cat ip_stats.txt | tail -n 16 >  /usr/local/apache/htdocs/latest_ip_stats.txt
cat ip_stats.txt  > /usr/local/apache/htdocs/ip_stats.txt
cat stats.txt | tail -n 5 >  /usr/local/apache/htdocs/latest_stats.txt
cat stats.txt > /usr/local/apache/htdocs/stats.txt
rm -f ${DATE}_uniq
