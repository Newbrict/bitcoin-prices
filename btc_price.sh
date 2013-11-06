bitstamp="$(curl -s "https://www.bitstamp.net/api/ticker/")"
bitstamp="$(echo "$bitstamp" | cut -d ',' -f2  | cut -d ':' -f2)"
bitstamp="$(echo "$bitstamp" | perl -pe "s/[\"| ]//g")"

coinbase="$(curl -s "https://coinbase.com/api/v1/prices/spot_rate")"
coinbase="$(echo "$coinbase" | cut -d ',' -f1  | cut -d ':' -f2)"
coinbase="$(echo "$coinbase" | perl -pe "s/[\"| ]//g")"

mtgox="$(curl -s "http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast")"
mtgox="$(echo "$mtgox" | cut -d ',' -f10  | cut -d ':' -f2)"
mtgox="$(echo "$mtgox" | perl -pe "s/[\"| ]//g")"

btce="$(curl -s "https://btc-e.com/api/2/btc_usd/ticker")"
btce="$(echo "$btce" | cut -d ',' -f6 | cut -d ':' -f2)"
btce="$(echo "$btce" | perl -pe "s/[\"| ]//g")"

echo -e "MtGox:    $mtgox
Coinbise: \$$coinbase
Bitstamp: \$$bitstamp
BTC-e:    \$$btce"
