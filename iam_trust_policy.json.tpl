{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": [
        "apigateway.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}
