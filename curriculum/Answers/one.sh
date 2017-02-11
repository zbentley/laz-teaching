#!/bin/bash

while read p;
do
echo ${p:0:1};
done <words | tr '[a-z]' -r | uniq | less | head -26 | sort -r
