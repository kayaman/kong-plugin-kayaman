HOST_IP=172.20.10.7

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

curl -i -X POST --url http://localhost:8001/services/ \
                --data 'name=belgium-service' \
                --data 'protocol=http' \
                --data 'host=belgium_cluster' \
                --data 'port=6002' \
                --data 'path=/' 
                
curl -X POST --url http://localhost:8001/services/europe-service/routes \
                --data 'paths[]=/local' 

curl -X POST --url http://localhost:8001/services/italy-service/routes \
                --data 'paths[]=/local'

 curl -X POST --url http://localhost:8001/services/belgium-service/routes \
                --data 'paths[]=/local'

EU_ID=$(curl -X POST --url http://localhost:8001/upstreams --data 'name=europe_cluster' | jq -r '.["id"]' ) 
IT_ID=$(curl -X POST --url http://localhost:8001/upstreams --data 'name=italy_cluster' | jq -r '.["id"]' ) ;
BE_ID=$(curl -X POST --url http://localhost:8001/upstreams --data 'name=belgium_cluster' | jq -r '.["id"]' ); 

curl -i -X POST --url http://localhost:8001/upstreams/$EU_ID/targets \
                --data "target=${HOST_IP}:6000"
curl -i -X POST --url http://localhost:8001/upstreams/$IT_ID/targets \
                --data "target=${HOST_IP}:6001";
curl -i -X POST --url http://localhost:8001/upstreams/$BE_ID/targets \
                --data "target=${HOST_IP}:6002";