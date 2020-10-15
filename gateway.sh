#!/bin/bash
set -e

stage_name="local"
region="us-east-1"
api_name="Gateway"
service_url="YOUR_URL"

echo "Start creating WebSocket API"
api=$(
    aws apigatewayv2 create-api \
    --region $region \
    --name $api_name \
    --protocol-type WEBSOCKET \
    --route-selection-expression \$request.body.action
)
echo "WebSocket API successfully created"

echo "WebSocket API: $api"

api_id=$(echo "${api}" | jq -r '.ApiId')
echo "Api ID: $api_id"

echo "Start creating integrations"
echo "Start creating integration for route -> \$default"
integration_for_route_default=$(
    aws apigatewayv2 create-integration \
    --api-id $api_id \
    --integration-type HTTP_PROXY \
    --integration-method GET \
    --integration-uri "$service_url/onmessage"
)

integration_id_for_route_default=$(echo "${integration_for_route_default}" | jq -r '.IntegrationId')

echo "Successfully created integration for route -> \$default"
echo "Integration ID (default route): $integration_id_for_route_default"

echo "Start creating integration for route -> \$connect"
integration_for_route_coawGET \
    --integration-uri "$service_url/onconnect"
)

integration_id_for_route_connect=$(echo "${integration_for_route_connect}" | jq -r '.IntegrationId')

echo "Successfully created integration for route -> \$connect"
echo "Integration ID (connect route): $integration_id_for_route_connect"

echo "Start creating integration for route -> \$disconnect"
integration_for_route_disconnect=$(
    aws apigatewayv2 create-integration \
    --api-id $api_id \
    --integration-type HTTP_PROXY \
    --integration-method GET \
    --integration-uri "$service_url/ondisconnect"
)

integration_id_for_route_disconnect=$(echo "${integration_for_route_disconnect}" | jq -r '.IntegrationId')

echo "Integration ID (disconnect route): $integration_id_for_route_disconnect"
echo "Successfully created all integrations"

echo "Start creating routes"

echo "Start creating route -> \$default"
default_route=$(
    aws apigatewayv2 create-route \
    --region $region \
    --api-id $api_id \
    --route-key "\$default" \
    --target integrations/$integration_id_for_route_default
)
echo "Successfully created route -> \$default"

echo "Start creating route -> \$connect"
connect_route=$(
    aws apigatewayv2 create-route \
    --region $region \
    --api-id $api_id \
    --route-key "\$connect" \
    --target integrations/$integration_id_for_route_connect
)
echo "Successfully created route -> \$connect"

echo "Start creating route -> \$disconnect"
disconnect_route=$(
    aws apigatewayv2 create-route \
    --region $region \
    --api-id $api_id \
    --route-key "\$disconnect" \
    --target integrations/$integration_id_for_route_disconnect
)
echo "Successfully created route -> \$default"

echo "Start creating deployment"
deployment=$(
    aws apigatewayv2 create-deployment \
    --region $region \
    --api-id $api_id
)
echo "Successfully created deployment"

deployment_id=$(echo "${deployment}" | jq -r '.DeploymentId')
echo "Deployment ID: $deployment_id"

echo "Start creating stage"
stage=$(
    aws apigatewayv2 create-stage \
    --region $region \
    --api-id $api_id \
    --deployment-id $deployment_id \
    --stage-name $stage_name
)
echo "Successfully created stage: $stage"
