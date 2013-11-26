#! /bin/bash

# this is an example of how to read the data from btcp.sh

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
exchanges="$base/exchanges/.config.txt"

# run the collector if it's not running
[[ ! $(pgrep btcp.sh) ]] && ($base/btcp.sh &) &&
	echo "Starting gatherer, rerun after 1 minute for real data" && exit 0

# display prices for each exchange
s1="-10s"
s2="-7.2f"
while read ex; do
		price="$($base/exchanges/$ex/price.sh)"
		diff="0"

		lastf="$base/exchanges/$ex/data/price.txt"
		lastp="$price"
	
		# if no last price
		[[ ! -f "$lastf" ]] &&
			printf "%$s1|\e[40m\e[0;35m%$s2 (?)\e[0m\n" $ex $price&&
			echo "$price" > "$lastf" && continue
		lastp="$(cat $lastf)"


		# if price is 0
		[[ "$price" = "0" ]] &&	
			printf "%$s1|\e[40m\e[0;35m%$s2 (?)\e[0m\n" $ex $lastp && continue

		# store this price
		echo "$price" > "$lastf"
		

	
		diff="$(bc <<< "$price-$lastp")"
		printf "%$s1|" $ex
		if [ "$diff" = "0" ]
		then
			printf "\e[40m\e[0;37m%$s2 (%.2f)\e[0m\n" $price $diff
		elif [ "$(echo $diff | grep -o "-")" == "-" ]
		then
			printf "\e[40m\e[0;31m%$s2 (%.2f)\e[0m\n" $price $diff
		else
			printf "\e[40m\e[0;32m%$s2 (+%.2f)\e[0m\n" $price $diff
		fi
done < "$exchanges"
