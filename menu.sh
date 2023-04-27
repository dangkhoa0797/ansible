#!/bin/bash
now=`date +%d_%m_%Y_%H:%M:%S`

echo_hello () {
    echo "Hello!!!"
}

touch_file () {
    touch date_$now
    ls -l date_$now*
}

while true; do
    options=("Hello" "Create file now" "Quit")

    echo "Choose an option: "
    select opt in "${options[@]}"; do
        case $REPLY in
            1) echo_hello; break ;;
            2) touch_file; break ;;
            3) break 2 ;;
            *) echo "What's that?" >&2
        esac
    done
done

echo "Bye bye!"
