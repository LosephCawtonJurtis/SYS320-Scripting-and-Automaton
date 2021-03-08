#!/bin/bash

# script to perform local security checks

function checks() {
	if [[ $2 != $3 ]]
	then
	
		echo "The $1 max days policy is not compliant. the current policy is: $2. the current value is $3"

	else

		echo "The $1 is Compliant. The current value is $3"

	fi
}

#Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ') 

# Check for password max
checks "Password Max Days" "365" "${pmax}"

#Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')

checks "password min days" "14" "${pmin}"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "password warn age" "7" "${pwarn}"
