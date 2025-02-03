# isc-iop-ex2

InterSystems IRIS Interoperability OAuth error scenarios example.

The host names are specific for my setup. Requires WireMock Standalone. WireMock has different scenarios.

WireMock scenarios:
* `wiremock/01/` - happy path
* `wiremock/02/` - `ERROR #8860: Unexpected expires_in value in access token response: 0.`
* `wiremock/03/` - invalid JSON: `ERROR #5035: General exception Name 'Parsing error' Code '3' Data ''`
* `wiremock/04/` - All different WireMock [corrupted responses](https://wiremock.org/docs/simulating-faults/#bad-responses) that trigger: `ERROR #6097: Error '<READ>zRead+28^%Net.HttpRequest.1' while using TCP/IP device '9999'`. You have to `Run()` several times as there is several differents responses bundled.
* `wiremock/05/` - Delay simulations from [Simulating Faults](https://wiremock.org/docs/simulating-faults/). All calls are expected to run succesfully. You have to `RevokeAuth()` and `Run()` several times as there is several differents responses bundled.

Run WireMock scenario:
```
<WIREMOCK> --disable-gzip --print-all-network-traffic --https-port 8443 --port 8080 --root-dir wiremock/SCENARIO/
```

Run application:
```
NAMESPACE>zw ##class(janihur.Runner).Run()
```

Reset authentication manually when needed:
```
NAMESPACE>do ##class(janihur.BusinessOperation).RevokeAuth()
```

## OAuth2.0 Configuration

We're using password grant type

In Management Portal:
1. Go to page: `System administration > Security > OAuth 2.0 > Client`
1. Press button: `Create Server Description`
1. Press button: `Manual` (shows more values in the form)
1. Fill in the following data:

|Key                  |Value                             |
|---------------------|----------------------------------|
|Issuer endpoint      |`http://host.docker.internal:8080/isciopex2/auth/token`|
|SSL/TLS configuration|`ISC.FeatureTracker.SSL.Config`|
|Authorization server/<br/>Authorization endpoint|`-`|
|Authorization server/<br/>Token endpoint|`http://host.docker.internal:8080/isciopex2/auth/token`|

5. Press button: `Save`
1. Click link: `Client Configurations`
1. Press button: `Create Client Configurations`
1. Fill in the following data:

|Tab               |Key                  |Value                          |
|------------------|---------------------|-------------------------------|
|General           |Application name     |`isciopex2-client`             |
|General           |Client Type          |`Confidental`                  |
|General           |SSL/TLS configuration|`ISC.FeatureTracker.SSL.Config`|
|General           |Client redirect URL/<br/>Host name|`localhost`|
|General           |Required grant types (check at least one)|`Client credentials` (check only this value)|
|General           |Authentication type  |`basic`                        |
|Client Credentials|Client ID            |`isciopex2-client-id`          |
|Client Credentials|Client secret        |`isciopex2-client-secret`      |

9. Press button: `Save`

## How to make the JWT

Create RSA key pair:
```
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

Create JWT:
```
./jwt.sh
```

Add the JWT into access token JSON file:
```
{
    "access_token": "JWT HERE",
    "token_type": "bearer",
    "expires_in": 3600,
    "jti": "bc766749-0b29-4d43-b9bb-a13a1d0c4d8a",
    "scope": "isciopex2-scope"
}
```