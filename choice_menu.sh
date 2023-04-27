#!/bin/bash
now=$(date +"%d_%m_%Y_%H:%M:%S")
# now=`date +%d_%m_%Y_%H:%M:%S`


PS3="Select your choice please: "

select lng in A B C Quit
do
    case $lng in
        "A")
            echo "$lng - choice A";;
        "B")
           echo "$lng - choice B";;
        "C")
           echo "$lng - choice C";;
        "Quit")
           echo "We're done"
           break;;
        *)
           echo "invalid option $REPLY";;
    esac
done