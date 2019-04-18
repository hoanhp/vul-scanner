#!/bin/bash

recon() {
  domain=$1

  python ~/toys/Sublist3r/sublist3r.py -d $domain -t 10 -v -o ./subdomain/$domain.txt
  curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain >> ./subdomain/$domain.txt
  cat ./subdomain/$domain.txt | sort -u > ./subdomain/tmp.txt; cat ./subdomain/tmp.txt > ./subdomain/$domain.txt; rm ./subdomain/tmp.txt
}

logo() {
	echo '''
  _   _   _   _   _   _   _   _   _   _   _   _   _   _  
 / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
( B | O | U | N | T | Y | - | S | C | A | N | N | E | R )
 \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
 							by @vinamilk

	'''
	sleep 1
}

remove_if_exit() {
	path_to_file=$1
	if [ -f $path_to_file ]; then
  		rm $path_to_file
  	fi
}

main() {
	clear
	logo

	if [ ! -f "./subdomain/" ]; then
    	mkdir -p "./subdomain/"
  	fi

	cat ./targets.txt | sort -u | while read line; do
	    sleep 1
	    remove_if_exit ./subdomain/$line.txt
	    recon $line
  	done

  	_date=$(date +"%Y-%m-%d").txt
  	remove_if_exit ./results/$_date.txt

  	cat ./subdomain/*.txt | sort -u | while read line; do
  		python ./exploit/test.py $line $_date
  	done
}

main