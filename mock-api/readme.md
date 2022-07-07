# Eventhos integration test server

This a server that should be used in the eventhos integration tests.

## PORT configuration

You should enter the desired port by a environment variable. The default port is 1000.

```text
PORT=1000
```

## Endpoints

| Endpoint       | Method | Description                                                                                                                                                                                 |
| -------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/token`       | `POST` | If the grant_type, client_id and client_secret are send in the request body will respond with: { content: { access_token: "token_021", } }. Else it will response with a status code of 400 |
| `/integration` | `GET`  | Responds with a json object where the content indicates the last query, body and headers received.                                                                                          |
| `/integration` | `POST` | Registers the query, body and headers of the request.                                                                                                                                       |
| `/clean`       | `GET`  | Realizes a cleanup of the variables so another test instance can run.                                                                                                                       |
