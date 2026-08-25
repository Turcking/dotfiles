#! /usr/bin/env sh

# Terminate already running variety instances
variety -q

# Wait until the processes have been shut down
while pgrep -u $UID -x variety >> /dev/null; do
	sleep 1
done

# Launch variety
exec variety

