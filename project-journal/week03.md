# Decentralized Authentication with Cognito
- Amazon Cognito lets you easily add user sign-up and authentication to your mobile and web apps.


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
import { Amplify } from 'aws-amplify';

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_AWS_PROJECT_REGION,
  "aws_cognito_identity_pool_id": process.env.REACT_APP_AWS_COGNITO_IDENTITY_POOL_ID,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
Auth: {
  region: process.env.REACT_AWS_PROJECT_REGION,
  userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,
  userPoolWebClientId: process.env.REACT_APP_AWS_USER_POOLS_WEB_CLIENT_ID,
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
## 3. Conditionally show components based on logged in or logged out
- Go to `HomeFeedPage.js` file
- Replace code in line 40 - 49 with the following block of code

```js
const checkAuth = async () => {
  Auth.currentAuthenticatedUser({
    bypassCache: false
  })
  .then((user) => {
    console.log('user', user);
    return Auth.currentAuthenticatedUser();
  })
  .then((cognito_user) => {
    setUser({
      display_name: cognito_user.attributes.name,
      handle: cognito_user.attributes.preferred_username
    });
  })
  .catch((err) => console.log(err));
};

React.useEffect(() => {
  loadData();
  checkAuth();
}, []);
```

Replace line 6 with the following block of code

```js
import { Auth } from 'aws-amplify';

const signOut = async () => {
  try {
    await Auth.signOut({ global: true });
    window.location.href = "/";
  } catch (error) {
    console.log('error signing out: ', error);
  }
}
```

### Pitfalls You May Encounter
**1. Amplify Auth Import Error**

Error:
```bash
Attempted import error: 'Auth' is not exported from 'aws-amplify'
```

**Explanation:**
As of AWS Amplify v5, the packages have been modularized. Auth is no longer exported directly from `aws-amplify`.

#### Fix Option 1: Downgrade to v4

Run this to see what version you're on:
```bash
npm list aws-amplify
```
If you're on `^v5.x.x`, you must use modular imports. If you'd rather revert to the monolithic v4 behavior, you can downgrade:

```bash
npm install aws-amplify@4
```

#### Fix 2. Install the new Auth package

```bash
npm install @aws-amplify/auth
```

Update your imports everywhere you use Auth:
***Before (incorrect):***

```js
import { Auth } from 'aws-amplify';
```

***After (correct):***
```js
import { Auth } from '@aws-amplify/auth';
```

**2. Misconfiguration with your AWS Cognito app client**
*Make use of the inspect tool. It sees what you cannot see*

**Likely error:**
```console
NotAuthorizedException: Client <your_client_id> is configured with secret but SECRET_HASH was not received
```

**What It Means**
- Your Cognito User Pool App Client is configured with a client secret, but your frontend is not sending that `SECRET_HASH` — and AWS requires it when a client secret is enabled.

- The SECRET_HASH is used for enhanced security. But AWS Amplify does not support client secrets in frontend apps, since it would expose that secret in the browser.

#### Solution
**Disable the client secret**
- Go to the Amazon Cognito Console

- Choose User Pools > your pool

- In the App Clients tab, find the client with ID 41c7of3b23th78hclfp3p9n94n

- Delete it if it can't be edited (the secret cannot be removed)

- Create a new App Client:

- Give it a name like frontend-client

- DO NOT check "Generate client secret"

- Save it

- Update your env variable


### Backend authentication - JWTs
#### Update app.py
```js
cors = CORS(
  app, 
  resources={r"/api/*": {"origins": origins}},
  headers=['Content-Type', 'Authorization'], 
  expose_headers='Authorization',
  methods="OPTIONS,GET,HEAD,POST"
)
```

#### Update `backend-flask/requirements.txt` file
`Flask-AWSCognito` - Extension for Flask that adds support for AWSCognito into your application.

Navigate to `backend-flask` and run `pip install -r requirements.txt`

#### Update `docker-compose.yml` file
Under the backend-flask service add:

```yml
AWS_COGNITO_USER_POOL_ID: "us-east-1_7LwuPwMbu"
AWS_COGNITO_USER_POOL_CLIENT_ID: "7o94ur1bgsmlp6ed0dbnnk0bm6"
AWS_PROJECT_REGION: "${AWS_DEFAULT_REGION}"

```


