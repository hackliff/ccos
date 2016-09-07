# Crypto Configuration

The goal of this implementation is to address security concerns
about [12 factors app configuration approch]() (i.e. based on
environment variables).


## Usage

### Create and export the application specific token

Create a new polici for the app `example` in policies/example.hcl. it
will provide read authorization over global apps knowledge, and
read/write access to its own config.

Setup the app configuration and authentification policy with
`./bootstrap.sh`.

Then write the configuration template in `./config.yaml`.

Finally use the crypto loader to populate the configuration in-memory
and send it on stdout.

```Bash
$ go run main.go
---
server:
  host: "localhost"
  port: 3000

api_key: "qwerty"
```

So in case you write an app (say `example.py`) that loads `yaml` on
`stdin`, we can use a pipe like so :

```Bash
(vault)  crypto-loader git:(exp/vault-env) ✗ go run main.go |
./example.py
{'server': {'host': 'localhost', 'port': 3000}, 'api_key': 'qwerty'}
```

## Service discovery

```Bash
$ docker run \
  --name consul \
  --hostname server-1 \
  -p 8301:8301 -p 8400:8400 -p 8500:8500 -p 8600:8600 -p 53:53 \
  consul:v0.6.4 agent -server -bootstrap-expect 1 -client 0.0.0.0 -advertise=172.17.0.2

$ # start a simple backend for various load balancing demos
$ docker run -d --name hello -p 8080:80 nginxdemos/hello

$ curl -XPUT -d@services/hello.json $CONSUL_ADDR/v1/catalog/register
$ curl $CONSUL_ADDR/v1/catalog/nodes
```
