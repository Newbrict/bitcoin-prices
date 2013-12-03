#! /bin/bash

# this is an example of how to read the data from btcp.sh

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
exchanges="$base/exchanges/.config.txt"

# run the collector if it's not running
[[ ! $(pgrep btcp.sh) ]] && ($base/btcp.sh &) &&
	echo "Starting gatherer, rerun after 1 minute for real data" && exit 0

#formatting vars
s1="-9s"
s2="8.2f"
s3="+ 8.2f"
red="\e[0;31m"
gre="\e[0;32m"
whi="\e[0;37m"
prp="\e[0;35m"
clr="\e[0m"
err="7s"
errsym="?"

# display prices for each exchange
while read ex; do
		price="$($base/exchanges/$ex/price.sh)"
		diff="0"

		lastf="$base/exchanges/$ex/data/price.txt"
		lastp="$price"
	
		lasterr="$whi%$s1$whi|$prp%$s2$whi| $prp%$err$clr\n"
		# if no last price
		[[ ! -f "$lastf" ]] &&
			printf "$lasterr" $ex $price $errsym &&
			echo "$price" > "$lastf" && continue
		lastp="$(cat $lastf)"


		# if price is 0
		[[ "$price" = "0" ]] &&	
			printf "$lasterr" $ex $lastp $errsym &&
			continue

		# store this price
		echo "$price" > "$lastf"
		

	
		diff="$(bc <<< "$price-$lastp")"
		printf "$whi%$s1|" $ex
		if [ "$diff" = "0" ]
		then
			printf "%$s2$whi|%$s3$clr\n" $price $diff
		elif [ "$(echo $diff | grep -o "-")" == "-" ]
		then
			printf "$red%$s2$whi|$red%$s3$clr\n" $price $diff
		else
			printf "$gre%$s2$whi|$gre%$s3$clr\n" $price $diff
		fi
done < "$exchanges"
