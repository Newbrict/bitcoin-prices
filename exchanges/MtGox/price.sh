base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
out="$base/data/api.txt"
[[ -f $out ]] &&
	price="$(cat $out | cut -d ',' -f10  | cut -d ':' -f2 | perl -pe "s/[\$ | \"| ]//g")" &&
	[[ $price = *[0-9]* && $price = ?([+-])*([0-9])?(.*([0-9])) ]] &&
		echo $price ||
		echo 0

