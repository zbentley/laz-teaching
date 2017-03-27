#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Try again!";
fi

if [ $# -gt 0 ]; then
	i=$1

	if [[ "${i:0:1}" == 'a' && "${i:(-1)}" == 'a' ]]; then
		echo "Success!"
	else
		echo "Nice try!"
	fi
fi


