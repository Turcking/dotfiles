#! /usr/bin/env sh

# Terminate already running lxpolkit instances
killall -u $USER -q lxpolkit

# Wait until the processes have been shut down
while pgrep -u $UID -x lxpolkit >> /dev/null; do
	sleep 1
done

# Launch lxpolkit
exec lxpolkit

