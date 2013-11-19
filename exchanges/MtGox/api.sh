base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "http://data.mtgox.com/api/2/BTCUSD/money/ticker_fast" > $base/data/api.txt
