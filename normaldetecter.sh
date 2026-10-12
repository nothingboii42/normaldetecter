#!/bin/bash

# check for checkm8 normal devices
# doesnt check for newer iphones or older iphones

pids=("12a8" "12ab" "12aa")

connected_linux=$(lsusb -d 05ac: 2>/dev/null)
connected_darwin=$(system_profiler SPUSBDataType 2>/dev/null | grep -i "Product ID:")

detected_device="false"

start_darwin() {
    sleep 2
    for pid in "${pids[@]}"; do
	if [[ "$connected_darwin" == *"0x$pid"* ]]; then
	    detected_device="true"
	    echo "founded ${pid} connected"
	fi

	if [ "$detected_device" == "false" ]; then
	    start_darwin
	fi
    done
}

start_linux() {
    sleep 2
    for pid in "${pids[@]}"; do
	if [[ "$connected_linux" == *":$pid"* ]]; then
	    detected_device="true"
	    echo "founded ${pid} connected"
	fi

	if [ "$detected_device" == "false" ]; then
            start_linux
        fi
    done
}

case "$(uname)" in
    Darwin)
	echo "waiting for device"
	start_darwin
	;;
    Linux)
	echo "waiting for device"
	start_linux
	;;
    *)
	echo "unknown OS"
	exit 1 ;;
esac
