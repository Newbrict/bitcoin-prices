#! /bin/bash

# this updates the exchanges/*/data/api.txt file with the bitcoin data,
#	run this in the background then run scripts to read from that file

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# get frequency, do not set this lower than 10
[[ $#>0 ]] && freq="$1" || freq="1m"

# loop to send out all API requests in the background
while [ true ]; do
	ls -1 "$base/exchanges/" > .config.txt
	exchanges="$base/exchanges/.config.txt"
	# for each exchange run their api call
	while read ex; do
		[[ ! -d "$base/exchanges/$ex/data/" ]] &&
			mkdir "$base/exchanges/$ex/data/"
	 	$base/exchanges/$ex/api.sh &
	done < "$exchanges"
  sleep $freq
done
