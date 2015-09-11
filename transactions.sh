./$1/api.sh -m listtransactions | grep -e 'amount' -e '"time"' -e '"account"'|  sed -e 's|.*time"\: \([^,]*\),|date -d@\1;echo|' -e "s|.*\(\"a.*\)|echo '\1'|" |sh
