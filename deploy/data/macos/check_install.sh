#!/bin/bash
if [ -d "/Applications/DefaultVPN.app" ] || pgrep -x "DefaultVPN-service" >/dev/null; then
  exit 1
fi
exit 0
