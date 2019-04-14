kong-plugin-kayaman
===================
[![Website][website-badge]][website-url][![Documentation][documentation-badge]][documentation-url][![Kong Nation][kong-nation-badge]][kong-nation-url][![Build Status](https://travis-ci.com/kayaman/kong-plugin-kayaman.svg?branch=master)](https://travis-ci.com/kayaman/kong-plugin-kayaman)

## Goal

This plugin can proxy requests from specific routes to different upstreams based on the presence of specific headers.

**Disclaimer:** everything is hardcoded at the moment. Work in progress...

## Usage

### Standard request

```shell
curl -i http://localhost:8000/local
```

**Response:**

```shell
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Connection: keep-alive
X-Kong-Upstream-Latency: 6
X-Kong-Proxy-Latency: 1
Via: kong/1.1.1

Saluti :-)
```



### Proxied request

```shell
curl -i -H "X-Country: Italy" http://localhost:8000/local
```

**Response:**

```shell
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Connection: keep-alive
X-Kong-Upstream-Latency: 6
X-Kong-Proxy-Latency: 2
Via: kong/1.1.1

Greetings :-)
```



## Setup

Assuming you have Kong installed and running locally. Let's work on setting up a minimal environment to play. 

### Services

```shell
curl -i -X POST --url http://localhost:8001/services/ \
                --data 'name=europe-service' \
                --data 'protocol=http' \
                --data 'host=europe_cluster' \
                --data 'port=6000' \
                --data 'path=/'
```

```shell
curl -i -X POST --url http://localhost:8001/services/ \
                --data 'name=italy-service' \
                --data 'protocol=http' \
                --data 'host=italy_cluster' \
                --data 'port=6001' \
                --data 'path=/'
```



### Routes

```shell
curl -i -X POST --url http://localhost:8001/services/europe-service/routes \
                --data 'paths[]=/local'
```

```shell
curl -i -X POST --url http://localhost:8001/services/italy-service/routes \
                --data 'paths[]=/local'
```



### Upstreams

```shell
curl -i -X POST --url http://localhost:8001/upstreams \
                --data 'name=europe_cluster'
```

```shell
curl -i -X POST --url http://localhost:8001/upstreams \
                --data 'name=italy_cluster'        
```



### Targets

```shell
curl -i -X POST --url http://localhost:8001/upstreams/{europe-service-upstream-id}/targets \
                --data 'target={host IP address}:6000'
```

```shell
curl -i -X POST --url http://localhost:8001/upstreams/{italy-service-upstream-id}/targets \
                --data 'target={host IP address}:6001'
```

**Important**: Since we will be running all things in the same box, use the *host IP address* at this point. When running **Kong** from inside a container ([Vagrant](<https://github.com/Kong/kong-vagrant>) or *Docker*), using `localhost` or `127.0.0.1` won't work.



### Plugins

The plugin must be enabled either through the configuration file `kong.conf` or the specific environment variable.

```shell
export KONG_PLUGINS=bundled,kayaman
```

```shell
curl -i -X POST --url http://localhost:8001/plugins \
                --data 'name=kayaman'
```



## Mocked APIs

There are several approaches to this. I suggest using [ncat](https://nmap.org/ncat) or local instances of [httpbin](http://httpbin.org) using Docker.

### ncat

```shell
ncat --listen \
     --keep-open \
     --verbose \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nGreetings :-)'" \
     {host IP address} 6000
```

```shell
ncat --listen \
     --keep-open \
     --verbose \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nSaluti :-)'" \
     {host IP address} 6001
```



### Docker

```shell
docker run -d --name httpbin-6000 -p 6000:9000 shashiranjan84/httpbin
```

```shell
docker run -d --name httpbin-6001 -p 6001:9000 shashiranjan84/httpbin
```



## Kong Admin API

Some handy API requests

```shell
curl -i http://localhost:8001/services
curl -i http://localhost:8001/routes
curl -i http://localhost:8001/upstreams
curl -i http://localhost:8001/targets
curl -i http://localhost:8001/plugins
```

---

## Credits

Coded with :heart: by **m@rco.sh**.

[website-badge]: https://img.shields.io/badge/GETKong.org-Learn%20More-43bf58.svg
[documentation-url]: https://getkong.org/docs/
[documentation-badge]: https://img.shields.io/badge/Documentation-Read%20Online-green.svg
[kong-nation-url]: https://discuss.konghq.com/
[kong-nation-badge]: https://img.shields.io/badge/Community-Join%20Kong%20Nation-blue.svg