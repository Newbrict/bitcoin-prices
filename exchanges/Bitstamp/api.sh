base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "https://www.bitstamp.net/api/ticker/" > $base/data/api.txt
