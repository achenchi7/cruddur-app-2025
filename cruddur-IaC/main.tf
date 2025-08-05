## Create a user-pool in Amazon Cognito

resource "aws_cognito_user_pool" "cruddurpool" {
  name = "Cruddur-pool-1"
  username_attributes = [ "email" ]
  auto_verified_attributes = [ "email" ]
  

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  mfa_configuration = "OFF"
  
}

resource "aws_cognito_user_pool_client" "cruddur_client" {
  name = "cruddur-pool-client"
  user_pool_id = aws_cognito_user_pool.cruddurpool.id
  explicit_auth_flows = [ "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH" ] 
  generate_secret = false
  prevent_user_existence_errors = "LEGACY"
  refresh_token_validity = 1
  id_token_validity = 1
  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "hours"
  }
}