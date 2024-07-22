#!/bin/bash
set -e

# Define variables
stage_name="local"
region="us-east-1"
api_name="Gateway"
service_url="YOUR_URL"

# Function to create API and extract API ID
create_api_and_extract_id() {
    echo "Creating WebSocket API..."
    api=$(aws apigatewayv2 create-api \
            --region $region \
            --name $api_name \
            --protocol-type WEBSOCKET \
            --route-selection-expression '$request.body.action')
    api_id=$(echo "$api" | jq -r '.ApiId')
    echo "WebSocket API ID: $api_id"
}

# Function to create integration and return its ID
create_integration() {
    local route=$1
    local method=$2
    local uri=$3

    integration=$(aws apigatewayv2 create-integration \
                    --api-id $api_id \
                    --integration-type HTTP_PROXY \
                    --integration-method $method \
                    --integration-uri "$uri")
    echo $(echo "$integration" | jq -r '.IntegrationId')
}

# Function to create a route
create_route() {
    local route_key=$1
    local integration_id=$2

    aws apigatewayv2 create-route \
        --region $region \
        --api-id $api_id \
        --route-key "$route_key" \
        --target "integrations/$integration_id"
}

# Function to create a deployment and return its ID
create_deployment_and_extract_id() {
    deployment=$(aws apigatewayv2 create-deployment \
                    --region $region \
                    --api-id $api_id)
    echo $(echo "$deployment" | jq -r '.DeploymentId')
}

# Main execution starts here
create_api_and_extract_id

# Create integrations and routes
for route in "\$default" "\$connect" "\$disconnect"; do
    uri_suffix=$(echo "$route" | tr -d '$')
    integration_id=$(create_integration "$route" "GET" "$service_url/on${uri_suffix}")
    create_route "$route" "$integration_id"
    echo "Route $route with integration ID $integration_id created successfully."
done

# Create deployment and stage
deployment_id=$(create_deployment_and_extract_id)
echo "Deployment ID: $deployment_id created successfully."

echo "Creating stage..."
aws apigatewayv2 create-stage \
    --region $region \
    --api-id $api_id \
    --deployment-id $deployment_id \
    --stage-name $stage_name
echo "Stage $stage_name created successfully."
