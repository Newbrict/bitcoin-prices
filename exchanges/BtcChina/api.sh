base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -k -s "https://data.btcchina.com/data/ticker" > $base/data/api.txt
curl -s "http://rate-exchange.appspot.com/currency?from=CNY&to=USD" > $base/data/conv.txt
