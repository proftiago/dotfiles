#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)
case "$STATUS" in
"Playing") echo "󰏤" ;;
"Paused") echo "󰐊" ;;
*) echo "" ;;
esac
