ID=myid123

# Création de la fonction Lambda
echo "Création de la fonction Lambda..."
awslocal lambda create-function \
    --function-name localstack-lambda-multiply \
    --runtime nodejs18.x \
    --zip-file fileb://multiplicator.zip \
    --handler index.handler \
    --role arn:aws:iam::000000000000:role/lambda-role

# Création de l'API REST et récupération de l'ID
echo "Création de l'API REST..."
API_ID=$(awslocal apigateway create-rest-api --name 'API Gateway Lambda integration' --tags "_custom_id_"=$ID --query "id" --output "text")
echo "API_ID: $API_ID"

# Récupération du PARENT_ID (ID de la ressource racine)
echo "Récupération du PARENT_ID..."
PARENT_ID=$(awslocal apigateway get-resources --rest-api-id $API_ID --query "items[0].id" --output "text")
echo "PARENT_ID: $PARENT_ID"

# Création de la ressource et récupération du RESOURCE_ID
echo "Création de la ressource..."
RESOURCE_ID=$(awslocal apigateway create-resource \
    --rest-api-id $API_ID \
    --parent-id $PARENT_ID \
    --path-part "{somethingId}" --query "id" --output "text")
echo "RESOURCE_ID: $RESOURCE_ID"

# Ajout de la méthode POST
echo "Ajout de la méthode POST..."
awslocal apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method POST \
    --authorization-type NONE

# Intégration de la méthode POST avec Lambda
echo "Intégration avec Lambda..."
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:localstack-lambda-multiply/invocations \
    --passthrough-behavior WHEN_NO_MATCH

# Création du déploiement
echo "Création du déploiement..."
awslocal apigateway create-deployment \
    --rest-api-id $API_ID \
    --stage-name prod

echo "Configuration terminée !"
echo "API_ID: $API_ID"
echo "PARENT_ID: $PARENT_ID"
echo "RESOURCE_ID: $RESOURCE_ID" 
echo "API_URL: 'http://localhost:4566/restapis/$API_ID/prod/_user_request_/multiply'"