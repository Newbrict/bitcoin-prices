base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -s "https://coinbase.com/api/v1/prices/spot_rate" > $base/data/api.txt
