#
# Ubuntu 14.04 with activiti Dockerfile
#
FROM java:openjdk-7u79-jdk
MAINTAINER Jimmy Xu "xjimmyshcn@gmail.com"


RUN set -ex \
  && apt-get update \
  && apt-get install -y --no-install-recommends xfonts-utils \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 8080

ENV TOMCAT_VERSION 8.0.49
ENV ACTIVITI_VERSION 5.22.0
ENV MYSQL_CONNECTOR_JAVA_VERSION 5.1.37

RUN set -ex \
  && wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}.zip -O /tmp/mysql-connector-java.zip \
  && wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz \
  && wget https://github.com/Activiti/Activiti/releases/download/activiti-${ACTIVITI_VERSION}/activiti-${ACTIVITI_VERSION}.zip -O /tmp/activiti.zip \
  && tar xzf /tmp/catalina.tar.gz -C /opt \
  && ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
  && rm /tmp/catalina.tar.gz \
  && unzip /tmp/activiti.zip -d /opt/activiti \
  && rm -rf /opt/tomcat/webapps/examples \
  && rm -rf /opt/tomcat/webapps/docs \
  && unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-explorer.war -d /opt/tomcat/webapps/activiti-explorer \
  && unzip /opt/activiti/activiti-${ACTIVITI_VERSION}/wars/activiti-rest.war -d /opt/tomcat/webapps/activiti-rest \
  && unzip /tmp/mysql-connector-java.zip -d /tmp \
  && cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}-bin.jar /opt/tomcat/webapps/activiti-rest/WEB-INF/lib/ \
  && cp /tmp/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_JAVA_VERSION}-bin.jar /opt/tomcat/webapps/activiti-explorer/WEB-INF/lib/ \
  && rm /tmp/activiti.zip \
  && rm -rf /tmp/mysql-connector-java-5.1.37 \
  && rm /tmp/mysql-connector-java.zip


# Add font
COPY assets/font/YaHei.Consolas.1.12.ttf /usr/share/fonts/truetype/YaHei/YaHei.Consolas.1.12.ttf
RUN mkfontscale && mkfontdir && fc-cache -fv

# Patch(support CORS, chinese fonts)
ADD assets/patch/activiti-explorer /opt/tomcat/webapps/activiti-explorer/
COPY assets/patch/activiti-rest /opt/tomcat/webapps/activiti-rest/
COPY assets/config/tomcat/ROOT /opt/tomcat/webapps/ROOT/

# Add roles
ADD assets/config /assets/config/
ADD assets/init /assets/init
RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

ENV JAVA_OPTS="-Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -server -Xms32m -Xmx768m -XX:PermSize=64M -XX:MaxPermSize=256m"

CMD ["/assets/init"]
