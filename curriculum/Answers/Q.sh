#!/bin/bash

while read p;
do
if [[ ${p:0:1} == 'Q' || ${p:0:1} == 'X' ]]; then
echo ${p:0:5}
fi
done <words

