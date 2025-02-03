#!/bin/bash

HEADER='{
  "alg": "RS256",
  "typ": "JWT"
}'

HEADER_BASE64=$(echo -n "$HEADER" | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')

# sub (Subject): Identifies the principal that is the subject of the JWT. This is usually the user or the entity the token is about.
# exp (Expiration Time): Specifies the expiration time on or after which the JWT must not be accepted for processing. This is a timestamp in seconds since the Unix epoch. It helps to limit the token's validity period.
# iat (Issued At): Identifies the time at which the JWT was issued. This is a timestamp in seconds since the Unix epoch. It can be used to determine the age of the token.
# jti (JWT ID): Provides a unique identifier for the JWT. This can be used to prevent the token from being used more than once (replay attacks).
PAYLOAD='{
  "sub": "janihur",
  "iat": '$(date +%s)',
  "exp": '$(($(date +%s) + 3600))',
  "jti": "'"$(uuidgen)"'",
  "client_id": "isciopex2-client-id"
}'

PAYLOAD_BASE64=$(echo -n "$PAYLOAD" | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')

SIGNATURE=$(echo -n "$HEADER_BASE64.$PAYLOAD_BASE64" | openssl dgst -sha256 -sign private_key.pem | openssl base64 -e | tr -d '=' | tr '/+' '_-' | tr -d '\n')

JWT="$HEADER_BASE64.$PAYLOAD_BASE64.$SIGNATURE"
echo $JWT
