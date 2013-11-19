base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "https://btc-e.com/api/2/btc_usd/ticker" > $base/data/api.txt
