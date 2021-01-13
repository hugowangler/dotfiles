#!/bin/bash

#Terminate alread running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar  > /dev/null; do sleep 1; done

# Launch Polybar, using default config location, on all connected monitors
for monitor in $(xrandr -q | grep " connected " | awk '{print $1}')
do
	MONITOR=$monitor polybar -r example &
done
