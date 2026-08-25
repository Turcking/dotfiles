#! /usr/bin/env sh

# Terminate already running unclutter instances
killall -q unclutter

# Wait until the processes have been shut down
while pgrep -u $UID -x unclutter >> /dev/null; do
	sleep 1
done

# Launch unclutter
exec unclutter -b

