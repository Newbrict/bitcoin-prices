#! /bin/bash

# this updates the btcp.txt file with the bitcoin data, run this in the
# background then run scripts to read from that file and do everything else

# btcp.txt spec
# exchange:price:change
# *change from last check via this script

# exchanges:
# 0 : MtGox
# 1 : Coinbase
# 2 : Bitstamp
# 3 : Btc-e

# get frequency, do not set this lower than 10
[[ $#>0 ]] && freq="$1" || freq="1m"

# if this is the first time we run the script ( or btcp.txt was deleted )
[[ ! -f /tmp/btcp.txt ]] &&
	echo -e "0:0:0\n1:0:0\n2:0:0\n3:0:0\n" > /tmp/btcp.txt

# loop to send out all API requests in the background
# and aggregate results in the btcp.txt file
while [ true ]
do
	curl -s "http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast" > /tmp/btcp0.txt &
	curl -s "https://coinbase.com/api/v1/prices/spot_rate" > /tmp/btcp1.txt &
	curl -s "https://www.bitstamp.net/api/ticker/" > /tmp/btcp2.txt &
	curl -s "https://btc-e.com/api/2/btc_usd/ticker" > /tmp/btcp3.txt &
  sleep $freq
 
	# grab only the data we need from the ( should be ) json string
	mtgox="$(cat /tmp/btcp0.txt | cut -d ',' -f10  | cut -d ':' -f2)"
	mtgox="$(echo "$mtgox" | perl -pe "s/[\$ | \"| ]//g")"
	coinbase="$(cat /tmp/btcp1.txt | cut -d ',' -f1  | cut -d ':' -f2)"
	coinbase="$(echo "$coinbase" | perl -pe "s/[\"| ]//g")"
	bitstamp="$(cat /tmp/btcp2.txt | cut -d ',' -f2  | cut -d ':' -f2)"
	bitstamp="$(echo "$bitstamp" | perl -pe "s/[\"| ]//g")"
	btce="$(cat /tmp/btcp3.txt | cut -d ',' -f6 | cut -d ':' -f2)"
	btce="$(echo "$btce" | perl -pe "s/[\"| ]//g")"
	
	# grab old data so we can put that in place of garbage from apis
	old="$(cat /tmp/btcp.txt)"
	oldmtgox="$(echo "$old" | grep "^0" | cut -d ":" -f 2)"
	oldcoinbase="$(echo "$old" | grep "^1" | cut -d ":" -f 2)"
	oldbitstamp="$(echo "$old" | grep "^2" | cut -d ":" -f 2)"
	oldbtce="$(echo "$old" | grep "^3" | cut -d ":" -f 2)"

	# clear the btcp.txt file
	>/tmp/btcp.txt

	# push only valid numerical results to the btcp.txt file, sometimes
	# the apis fail and give us cloudflare docs or something....
  [[ $mtgox = *[0-9]* && $mtgox = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		chgmtgox="$(bc <<< "$mtgox-$oldmtgox")" &&
		echo "0:$mtgox:$chgmtgox" >> /tmp/btcp.txt
  [[ $coinbase = *[0-9]* && $coinbase = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		chgcoinbase="$(bc <<< "$coinbase-$oldcoinbase")" &&
		echo "1:$coinbase:$chgcoinbase" >> /tmp/btcp.txt
  [[ $bitstamp = *[0-9]* && $bitstamp = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		chgbitstamp="$(bc <<< "$bitstamp-$oldbitstamp")" &&
		echo "2:$bitstamp:$chgbitstamp" >> /tmp/btcp.txt
  [[ $btce = *[0-9]* && $btce = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		chgbtce="$(bc <<< "$btce-$oldbtce")" &&
		echo "3:$btce:$chgbtce" >> /tmp/btcp.txt
done
