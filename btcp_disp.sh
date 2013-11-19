#! /bin/bash

# this is an example of how to read the data from btcp.sh

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
exchanges="$base/exchanges/.config.txt"

# run the collector if it's not running
[[ ! $(pgrep btcp.sh) ]] && ($base/btcp.sh &) &&
	echo "Starting gatherer, rerun after 1 minute for real data" && exit 0

# display prices for each exchange
while read ex; do
		price="$($base/exchanges/$ex/price.sh)"
		diff="0"

		lastf="$base/exchanges/$ex/data/price.txt"
		lastp="$price"
	
		# if no last price
		[[ ! -f "$lastf" ]] &&
			echo -e $ex: "\e[40m\e[0;35m$price (?)\e[0m" &&
			echo "$price" > "$lastf" && continue
		lastp="$(cat $lastf)"


		# if price is 0
		[[ "$price" = "0" ]] &&	
			echo -e $ex: "\e[40m\e[0;35m$lastp (?)\e[0m" && continue

		# store this price
		echo "$price" > "$lastf"
		

	
		diff="$(bc <<< "$price-$lastp")"
		echo -ne "$ex: "
		if [ "$diff" = "0" ]
		then
			echo -e "\e[40m\e[0;37m$price ($diff)\e[0m"
		elif [ "$(echo $diff | grep -o "-")" == "-" ]
		then
			echo -e "\e[40m\e[0;31m$price ($diff)\e[0m"
		else
			echo -e "\e[40m\e[0;32m$price (+$diff)\e[0m"
		fi
done < "$exchanges"
