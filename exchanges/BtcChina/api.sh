base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "https://vip.btcchina.com/bc/ticker" > $base/data/api.txt
curl -s "http://rate-exchange.appspot.com/currency?from=CNY&to=USD" > $base/data/conv.txt
