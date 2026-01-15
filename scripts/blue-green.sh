#!/bin/bash

ACTIVE=$(cat /tmp/active_env 2>/dev/null || echo "blue")

if [ "$ACTIVE" == "blue" ]; then
  NEW="green"
else
  NEW="blue"
fi

echo "Deploying to $NEW environment"
echo $NEW > /tmp/active_env
