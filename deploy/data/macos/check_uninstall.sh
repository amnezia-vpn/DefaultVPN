#!/bin/bash
if [ -d "/Applications/DefaultVPN.app" ] || pgrep -x "DefaultVPN-service" >/dev/null; then
  exit 0
fi
exit 1
