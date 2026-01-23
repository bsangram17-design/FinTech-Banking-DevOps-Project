#!/bin/bash
set -e

# ===== CONFIG =====
LISTENER_ARN="arn:aws:elasticloadbalancing:ap-south-1:301139400808:listener/app/fintech-alb/05ca8c6ddaf7c995/c3b9fc4e5644eb58"
BLUE_TG_ARN="arn:aws:elasticloadbalancing:ap-south-1:301139400808:targetgroup/fintech-blue/38cc4e76af747b64"
GREEN_TG_ARN="arn:aws:elasticloadbalancing:ap-south-1:301139400808:targetgroup/fintech-green/7aad0dd76506f89a"
IMAGE="bsan17/fintech-api:latest"

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
