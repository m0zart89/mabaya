# mabaya home assignment

# Install
1. `git clone git@github.com:m0zart89/mabaya.git`
2. `touch ./logs/example.log && cd docker/terraform && terraform init && terraform apply -auto-approve && cd ../..`
3. [http://localhost:3000/d/000000003/echo-service-p99?orgId=1&refresh=10s](http://localhost:3000/d/000000003/echo-service-p99?orgId=1&refresh=10s) (admin;admin)
# Usage
1. Requests: 
```
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.5", "message": "bar"} 
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.5", "message": "bar"}
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.6", "message": "bar"}
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.5", "message": "bar"}
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.6", "message": "bar"}
user@localhost:~/repos/mabaya$ curl -X POST http://localhost:8000/foo -d "bar"
{"ip": "172.17.0.5", "message": "bar"}
```
2. Log file`./logs/example` :
```
2022-09-13 09:12:33,957 simple_server.py: ip: 172.17.0.5, path: /foo, body: bar
2022-09-13 09:12:34,298 simple_server.py: ip: 172.17.0.5, path: /foo, body: bar
2022-09-13 09:12:34,590 simple_server.py: ip: 172.17.0.6, path: /foo, body: bar
2022-09-13 09:12:34,845 simple_server.py: ip: 172.17.0.5, path: /foo, body: bar
2022-09-13 09:12:35,096 simple_server.py: ip: 172.17.0.6, path: /foo, body: bar
2022-09-13 09:12:35,344 simple_server.py: ip: 172.17.0.5, path: /foo, body: bar
```
3. Database: [http://localhost:8000/db](http://localhost:8000/db)
# Description
1. **Redundancy** achieved through 2 http workers `echo_service_1` and `echo_service_2`. In case of failure `echo_service_1` all traffic goes to the `echo_service_2`
2. **Service Percentile 99 Monitoring** is represented with Prometheus & Grafana stack: [http://localhost:3000/d/000000003/echo-service-p99?orgId=1&refresh=10s](http://localhost:3000/d/000000003/echo-service-p99?orgId=1&refresh=10s) (admin;admin)
# Desired Improvements
1. Terraform:
   * Parametrize worker count
   * Templating worker containers
   * Templating nginx conf (upstreams)
2. Mariadb:
   * Store data in volumes
# Uninstall
1. `cd docker/terraform && terraform destroy -auto-approve && cd ../..`
