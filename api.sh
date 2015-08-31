#!/bin/bash

#default parameters, empty
method='getinfo'
params='[]'
usage="
Usage: api.sh [options]

Available options:
-m <method> : Method
-p <params> : Single parameter or json object with multiple parameters
-l          : List

Examples:
./api.sh -m getbalance -p myaccount
./api.sh -m listreceivedbyaccount -p '{\"minconf\":1,\"includeempty\":true}'
"


while getopts ":m:p:l" opt; do
    case $opt in
        m)
            method=$OPTARG
            ;;
        p)
            if [[ "$OPTARG" =~ [\{\[\"] ]]
            then
                params=$OPTARG
            else
                params="[\"$OPTARG\"]"
            fi
            ;;
        :)
            echo "option -$OPTARG requires an argument" >&2
            exit 1
            ;;
        l)
            curl -s \
            https://talk.vanillacoin.net/topic/122/rpc-command-list | \
            grep -e '<tr>' -e '<td>[^<]' | \
            sed -e 's:<td>::g' -e 's:</td>::g' -e 's:&lt;:<:g' -e 's:&#123;:<:g' -e 's:&gt;:>:g' -e 's:&#125;:>:g' -e 's:<tr>: :g'
            exit 1
            ;;
        \?)
            echo "$usage"
            exit 1
            ;;
    esac
done

set -x
curl \
-H 'content-type: text/plain;' \
--data-binary "{\"jsonrpc\": \"1.0\", \"method\": \"$method\", \"params\": $params }" \
http://127.0.0.1:9195/ | python -m json.tool

