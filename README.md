REF: https://github.com/eternnoir/activiti.git

#Usage

## Build image
    ./build.sh

## Run
    docker-compose up

## View tomcat log
    docker-compose activiti-server

## View in browser
    http://<ip>:8888/activiti-explorer

## Test restful api(get user list)
    curl -s --header "Authorization:Basic a2VybWl0Omtlcm1pdA==" http://<ip>:8888/activiti-rest/service/identity/users/ | python -mjson.tool


## 如果要去掉内存限制

  去掉 ENV JAVA_OPTS -Xms32m -Xmx768m