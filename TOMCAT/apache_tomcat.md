# Apache tomcat

download fils on teams

1. jdk-12.0.1_linux-x64_bin.tar.gz
2. apache-tomcat-10.0.0-M1.tar.gz

rsync user to vm

```shell
rsync -azP /mnt/e/Dorian/Cours/*.tar.gz  dorian@10.24.200.24:/home/dorian/
```

## on VM in `root`

```shell
cd /home/dorian
mkdir /opt/{jdk,tomcat}
mv /home/dorian/jdk-12.0.1_linux-x64_bin.tar.gz /opt/jdk
mv /home/dorian/apache-tomcat-10.0.0-M1.tar.gz /opt/tomcat
```

```shell
tar -xvf /opt/jdk/jdk-12.0.1_linux-x64_bin.tar.gz
tar -xvf /opt/tomcat/apache-tomcat-10.0.0-M1.tar.gz
```

```shell
ln -s /opt/jdk/jdk-12.0.1/bin/java /usr/bin/java
ln -s /opt/jdk/jdk-12.0.1/bin/javac /usr/bin/javac
```

check java version

```shell
java --version
```

```shell
java 12.0.1 2019-04-16
Java(TM) SE Runtime Environment (build 12.0.1+12)
Java HotSpot(TM) 64-Bit Server VM (build 12.0.1+12, mixed mode, sharing)
```

start tomcat

```shell
chmod +x /opt/tomcat/apache-tomcat-10.0.0-M1/bin/startup.sh
/opt/tomcat/apache-tomcat-10.0.0-M1/bin/startup.sh
```

```shell
Using CATALINA_BASE:   /opt/tomcat/apache-tomcat-10.0.0-M1
Using CATALINA_HOME:   /opt/tomcat/apache-tomcat-10.0.0-M1
Using CATALINA_TMPDIR: /opt/tomcat/apache-tomcat-10.0.0-M1/temp
Using JRE_HOME:        /usr
Using CLASSPATH:       /opt/tomcat/apache-tomcat-10.0.0-M1/bin/bootstrap.jar:/opt/tomcat/apache-tomcat-10.0.0-M1/bin/tomcat-juli.jar
Tomcat started.
```

check if tomcat is running

```shell
telnet localhost 8080
```