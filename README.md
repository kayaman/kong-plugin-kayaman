kong-plugin-kayaman
===================
[![Build Status](https://travis-ci.com/kayaman/kong-plugin-kayaman.svg?branch=master)](https://travis-ci.com/kayaman/kong-plugin-kayaman)


## TODO: fix docs below:

--- cURLs --- 
curl -i -H "X-Country: Italy" http://localhost:8000/local
curl -i http://localhost:8000/local
---

--- setting up the Services, Routes, Upstreams, Targets and the Plugin ---

curl -i -X POST --url http://localhost:8001/services/ \
                --data 'name=europe-service' \
                --data 'protocol=http' \
                --data 'host=europe_cluster' \
                --data 'port=6000' \
                --data 'path=/'

curl -i -X POST --url http://localhost:8001/services/ \
                --data 'name=italy-service' \
                --data 'protocol=http' \
                --data 'host=italy_cluster' \
                --data 'port=6001' \
                --data 'path=/'

curl -i -X POST --url http://localhost:8001/services/europe-service/routes \
                --data 'paths[]=/local'

curl -i -X POST --url http://localhost:8001/services/italy-service/routes \
                --data 'paths[]=/local'

curl -i -X POST --url http://localhost:8001/upstreams \
                --data 'name=europe_cluster'

curl -i -X POST --url http://localhost:8001/upstreams \
                --data 'name=italy_cluster'                

curl -i -X POST --url http://localhost:8001/upstreams/f400b33f-fdfd-4056-a615-de2eb5f94b34/targets \
                --data 'target=172.20.10.7:6000'

curl -i -X POST --url http://localhost:8001/upstreams/116b14aa-e042-41ae-ba1d-93710df32a58/targets \
                --data 'target=172.20.10.7:6001'



curl -i -X POST --url http://localhost:8001/plugins \
                --data 'name=kayaman'
---

--- fake APIs ---

ncat --listen \
     --keep-open \
     --verbose \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nGreetings :-)'" \
     172.20.10.7 6000

ncat --listen \
     --keep-open \
     --verbose \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nSaluti :-)'" \
     172.20.10.7 6001


TODO: use Rob suggestion:
 docker run -d --name httpbin-9001 -p 9000:9000 shashiranjan84/httpbin

---

--- useful API requests ---

curl -i http://localhost:8001/services
curl -i http://localhost:8001/routes
curl -i http://localhost:8001/upstreams
curl -i http://localhost:8001/targets
curl -i http://localhost:8001/plugins

---

---

export KONG_PLUGINS=bundled,kayaman




