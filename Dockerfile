FROM ubuntu:quantal 

RUN apt-get update
RUN apt-get -y install wget


RUN wget -nv --no-cookies --no-check-certificate --header "Cookie: gpw_e24=h" http://download.oracle.com/otn-pub/java/jdk/7u45-b18/server-jre-7u45-linux-x64.tar.gz -O /tmp/server-jre-7u45-linux-x64.tar.gz

# Check the checksum, if it fails, print an error message
RUN echo "ba3a8e930d8dac68e965eb775ef7ef97  /tmp/server-jre-7u45-linux-x64.tar.gz" | md5sum -c > /dev/null 2>&1 || echo "ERROR: MD5SUM MISMATCH"

RUN tar xzf /tmp/server-jre-7u45-linux-x64.tar.gz

# Move to correct location
RUN mkdir -p /usr/lib/jvm
RUN mv jdk1.7.0_45 /usr/lib/jvm/java-7-oracle

# CHANGE OWNERSHIP (default is uucp!)
RUN chown root:root -R /usr/lib/jvm/java-7-oracle

# Cleanup
RUN rm /tmp/server-jre-7u45-linux-x64.tar.gz

# Enable environment
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV PATH $PATH:$JAVA_HOME/bin

# Retrieve latest tomcat8
RUN wget -O /tmp/tomcat.tar.gz http://apache.mirrors.lucidnetworks.net/tomcat/tomcat-8/v8.0.3/bin/apache-tomcat-8.0.3.tar.gz
RUN (cd /opt && tar zxf /tmp/tomcat.tar.gz)
RUN (mv /opt/apache-tomcat* /opt/tomcat)
ADD ./run.sh /usr/local/bin/run
EXPOSE 8080
CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
