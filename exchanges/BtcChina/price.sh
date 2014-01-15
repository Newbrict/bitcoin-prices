base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
out="$base/data/api.txt"
outc="$base/data/conv.txt"
[[ -f $out ]] &&
	price="$(cat $out | cut -d ':' -f7  | cut -d ',' -f1 | perl -pe "s/\"//g")" &&
	conv="$(cat $outc | cut -d ',' -f2  | cut -d ':' -f2 | perl -pe "s/\"//g")" &&
	[[ $price = *[0-9]* && $price = ?([+-])*([0-9])?(.*([0-9])) ]] &&
	[[ $conv = *[0-9]* && $price = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		echo $(echo "$price*$conv" | bc ) ||
		echo 0
