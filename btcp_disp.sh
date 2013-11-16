#! /bin/bash

# this is an example of how to read the data from btcp.sh

# run the collector if it's not running
[[ ! $(pgrep btcp.sh) ]] && (./btcp.sh &) &&
	echo "Starting gatherer, rerun after 1 minute for real data" && exit 0

# exit if there are no prices
[[ ! -f "/tmp/btcp.txt" ]] && echo "no prices found" && exit 1

# display prices
prices=$(cat /tmp/btcp.txt)

mtgox=$(echo "$prices" | grep "^0" | cut -d ":" -f 2-)
coinbase=$(echo "$prices" | grep "^1" | cut -d ":" -f 2-)
bitstamp=$(echo "$prices" | grep "^2" | cut -d ":" -f 2-)
btce=$(echo "$prices" | grep "^3" | cut -d ":" -f 2-)

function printer() {
	price="$(echo $2 | cut -d ":" -f 1)"
	diff="$(echo $2 | cut -d ":" -f 2)"

	echo -ne "$1: "
	if [ "$diff" = "0" ]
	then
		echo -e "\e[40m\e[0;37m$price ($diff)\e[0m"
	elif [ "$(echo $diff | grep -o "-")" == "-" ]
	then
		echo -e "\e[40m\e[0;31m$price ($diff)\e[0m"
	else
		echo -e "\e[40m\e[0;32m$price ($diff)\e[0m"
	fi
}

printer "MtGox" "$mtgox"
printer "Coinbase" "$coinbase"
printer "Bitstamp" "$bitstamp"
printer "Btc-e" "$btce"
