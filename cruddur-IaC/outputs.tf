output "user_pool_id" {
  description = "The ID of the Cognito User Pool."
  value       = aws_cognito_user_pool.cruddurpool.id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool."
  value       = aws_cognito_user_pool.cruddurpool.arn
}

output "user_pool_endpoint" {
  description = "The endpoint of the Cognito User Pool."
  value       = aws_cognito_user_pool.cruddurpool.endpoint
}

output "user_pool_client_id" {
  description = "The ID of the associated User Pool Client."
  value       = aws_cognito_user_pool_client.cruddur_client.id
}