#!/bin/bash

#default parameters, empty
method='getinfo'
params='[]'

while getopts ":m:p:l" opt; do
    case $opt in
        m)
            method=$OPTARG
            ;;
        p)
            params="[\"$OPTARG\"]"
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
            echo "Available options:"
            echo "-m <method> : Method"
            echo "-p <param>  : Parameter"
            echo "-l          : List"
            exit 1
            ;;
    esac
done

curl \
-H 'content-type: text/plain;' \
--data-binary "{\"jsonrpc\": \"1.0\", \"method\": \"$method\", \"params\": $params }" \
http://127.0.0.1:9195/
