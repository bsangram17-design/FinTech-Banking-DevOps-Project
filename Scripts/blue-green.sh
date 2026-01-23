#!/bin/bash
set -e

# ===== CONFIG =====
LISTENER_ARN="PASTE_LISTENER_ARN_HERE"
BLUE_TG_ARN="PASTE_BLUE_TG_ARN_HERE"
GREEN_TG_ARN="PASTE_GREEN_TG_ARN_HERE"
IMAGE="yourdockerhub/fintech-api:latest"

echo "Detecting active target group..."

ACTIVE_TG=$(aws elbv2 describe-listeners \
  --listener-arns $LISTENER_ARN \
  --query "Listeners[0].DefaultActions[0].TargetGroupArn" \
  --output text)

if [ "$ACTIVE_TG" == "$BLUE_TG_ARN" ]; then
  NEW_TG=$GREEN_TG_ARN
  OLD_TG=$BLUE_TG_ARN
  ENV="green"
else
  NEW_TG=$BLUE_TG_ARN
  OLD_TG=$GREEN_TG_ARN
  ENV="blue"
fi

echo "Deploying to $ENV environment..."

docker pull $IMAGE

docker stop fintech-$ENV || true
docker rm fintech-$ENV || true

docker run -d \
  --name fintech-$ENV \
  -p 80:5000 \
  $IMAGE

echo "Waiting for container to stabilize..."
sleep 10

echo "Switching ALB traffic..."
aws elbv2 modify-listener \
  --listener-arn $LISTENER_ARN \
  --default-actions Type=forward,TargetGroupArn=$NEW_TG

echo "Blue-Green deployment completed successfully."
