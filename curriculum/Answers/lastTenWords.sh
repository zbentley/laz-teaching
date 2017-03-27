#!/bin/bash

while read p;
do
echo ${p:0:5}
done <words | tail -10

