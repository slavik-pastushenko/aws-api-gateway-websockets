# AWS API Gateway v2

This script automates the process of creating a WebSocket API on AWS API Gateway, including the creation of integrations and routes for `$default`, `$connect`, and `$disconnect` actions, as well as the deployment and stage setup.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- `AWS CLI`: The script uses the AWS Command Line Interface. Ensure you have AWS CLI [installed](https://aws.amazon.com/cli/) and configured with the necessary access rights.
- `jq`: This script uses `jq` for JSON parsing. Ensure `jq` is [installed](https://jqlang.github.io/jq/) on your system.

## Configuration

Before running the script, update the following variables at the top of the script to match your configuration:

- `stage_name`: The name of the stage to create. Default is `"local"`.
- `region`: The AWS region where the API will be created. Default is `"us-east-1"`.
- `api_name`: The name of the WebSocket API. Default is `"Gateway"`.
- `service_url`: The URL of your service that will handle the WebSocket connections. Replace `"YOUR_URL"` with your actual service URL.

## Running the Script

The script will output the IDs of the created API, integrations, deployment, and stage. These IDs can be used for further configuration or for reference in AWS management console or CLI.

- Make the script executable:

```bash
chmod +x create_websocket_api.sh
```

- Run the script:

```bash
./create_websocket_api.sh
```

## What the Script Does

- Create WebSocket API: Initializes a WebSocket API on AWS API Gateway.
- Create Integrations: Sets up HTTP_PROXY integrations for $default, $connect, and $disconnect routes.
- Create Routes: Configures routes for the WebSocket API to handle different types of connections.
- Create Deployment: Deploys the API configuration.
- Create Stage: Sets up a stage for the deployed API, making it accessible.

## Troubleshooting

- Ensure your AWS CLI is correctly configured with the right permissions.
- Verify that jq is installed and accessible in your PATH.
- Check the AWS region and service URL are correctly set in the script.
- For more detailed logs, you can run the AWS CLI commands in the script with the `--debug` flag to get more insight into any issues.
