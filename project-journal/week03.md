# Decentralized Authentication with Cognito

Create a `userpool` in AWS via the management console
- User pools are user directories that provide sign-up and sign-in options for your web and mobile app users. AWS Cognito user pool is a way to provide Authentication to a user of an Application. It is represented as a user directory in Amazon Cognito.


- Implementing cognito into the app you have to use AWS Amplify
- AWS Amplify is a collection of cloud services and libraries for fullstack application development. Amplify provides frontend libraries, UI components, backend building, and frontend hosting for building fullstack cloud apps.

To get started:

## 1. Install AWS Amplify library
In the `frontend-react-js` directory

```yml
npm install aws-amplify --save
```
- The `--save` flag adds it to the `package.json` file

## 2. Configure AWS Amplify
- We need to hook up our cognito pool to our code in the App.js

- Add this lines of code in the `App.js` file
```js
import { Amplify } from 'aws-amplify'

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_AWS_PROJECT_REGION,
  "aws_cognito_identity_pool_id": process.env.REACT_APP_AWS_COGNITO_IDENTITY_POOL_ID,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
  Auth: {
    // We are not using an Identity Pool
    // identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID, // REQUIRED - Amazon Cognito Identity Pool ID
    region: process.env.REACT_AWS_PROJECT_REGION,           // REQUIRED - Amazon Cognito Region
    userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,         // OPTIONAL - Amazon Cognito User Pool ID
    userPoolWebClientId: process.env.REACT_APP_AWS_USER_POOLS_WEB_CLIENT_ID,   // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
  }
});
```

Populate these in the `docker-compose.yml` file in the `frontend` section. They are `env` variables.

```yml
REACT_APP_AWS_PROJECT_REGION: ${AWS_DEFAULT_REGION}
REACT_APP_AWS_COGNITO_IDENTITY_POOL_ID:
REACT_APP_AWS_COGNITO_REGION: ${AWS_DEFAULT_REGION}
REACT_APP_AWS_USER_POOLS_ID: "us-east-1_B6QxeFGZu"
REACT_APP_CLIENT_ID: "41c7of3b23th78hclfp3p9n94n"
```
