#!/bin/bash
# Uses ipdeny.com aggregated country block lists and iptables to block the
# worst offending countries, hosting bots, exploit scripts, spam and scammers.
#
# NOTE: This script can take many minutes to process as thousands of netblocks
# are added to iptables.
COUNTRIES="cn ru in kr vn tw sg ua br ro il do tn bd ga tj ng md"
BASE_URL="https://www.ipdeny.com/ipblocks/data/aggregated/"
URL_SUFFIX="-aggregated.zone"

echo "WARNING: iptables will be flushed."
echo "countryblock.sh adds thousands of netblocks for the following countries:"
echo "$COUNTRIES"
read -p "This script takes many minutes to complete. Press any key to continue"
iptables -F
for code in $COUNTRIES; do
	URL="$BASE_URL$code$URL_SUFFIX"
	echo $URL
	for ip in $(curl $URL); do
		iptables -A INPUT -j DROP -s $ip
	done
done
