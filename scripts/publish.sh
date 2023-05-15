#!/bin/sh

# Run in case the CI does not work properly
CHANNELS=( "$@" )

for CHANNEL in "${CHANNELS[@]}"
do
   ./scripts/ci/build-channel.sh "$CHANNEL"
   butler push build/$CHANNEL kuma-gee/lost-library:$CHANNEL
done