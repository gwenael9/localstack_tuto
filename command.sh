# créer fonction
awslocal lambda create-function \
    --function-name localstack-lambda-multiply \
    --runtime nodejs18.x \
    --zip-file fileb://multiplicator.zip \
    --handler index.handler \
    --role arn:aws:iam::000000000000:role/lambda-role

# création d'une API REST
awslocal apigateway create-rest-api --name 'API Gateway Lambda integration' --tags '{"_custom_id_":"myid123"}

# récupérer les ressources de l'API REST avec l'id
awslocal apigateway get-resources --rest-api-id flumcbjvri

# créer une nouvelle ressource pour l'API
awslocal apigateway create-resource   --rest-api-id flumcbjvri   --parent-id h3bsyphsyu   --path-part "{somethingId}"

# ajouter une méthode get
# awslocal apigateway put-method   --rest-api-id flumcbjvri   --resource-id g71tenmtu7   --http-method GET   --request-parameters "method.request.path.somethingId=true"   --authorization-type "NONE"

# ajouter une méthode post
awslocal apigateway put-method --rest-api-id kim5kaz3c9 --resource-id kajzcwx7hh --http-method POST --authorization-type NONE

# intègre la méthode get
# awslocal apigateway put-integration   --rest-api-id flumcbjvri   --resource-id g71tenmtu7   --http-method GET   --type AWS_PROXY   --integration-http-method POST   --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:localstack-lambda-url-example/invocations   --passthrough-behavior WHEN_NO_MATCH

# intégre la méthode post
awslocal apigateway put-integration   --rest-api-id kim5kaz3c9   --resource-id kajzcwx7hh   --http-method POST   --type AWS_PROXY   --integration-http-method POST   --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:localstack-lambda-url-example/invocations   --passthrough-behavior WHEN_NO_MATCH

# créer un déploiement
awslocal apigateway create-deployment   --rest-api-id kim5kaz3c9   --stage-name prod

# ----------------

# créer un S3
awslocal s3api create-bucket --bucket multiply-bucket

# Liste bucket
awslocal s3api list-buckets

# upload a file named index.html to your S3 bucket
awslocal s3api put-object --bucket multiply-bucket --key index.html --body ./frontend/index.html

# voir les objets dans le s3
awslocal s3api list-objects --bucket multiply-bucket