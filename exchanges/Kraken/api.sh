base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "https://api.kraken.com/0/public/Ticker?pair=xbtusd" > $base/data/api.txt
