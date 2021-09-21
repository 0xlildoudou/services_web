# TP 2

## Application 01

```shell
cp /home/dorian/appli01.zip /opt/tomcat/apache-tomcat-10.0.0-M1/webapps/
```

```shell
cd /opt/tomcat/apache-tomcat-10.0.0-M1/webapps/
```

```shell
unzip appli01.zip
```

Ajout d'un alias pour redémarrer tomcat

```shell
echo 'alias tomcat_shutdown="/opt/tomcat/apache-tomcat-10.0.0-M1/bin/shutdown.sh"' >> ~/.bashrc
echo 'alias tomcat_start="/opt/tomcat/apache-tomcat-10.0.0-M1/bin/startup.sh"' >> ~/.bashrc
echo 'alias tomcat_reboot="tomcat_shutdown && tomcat_start"' >> ~/.bashrc && source ~/.bashrc
```

Créer un user pour le manager dans le fichier `/opt/tomcat/apache-tomcat-10.0.0-M1/conf/tomcat-users.xml`

```XML
    <role rolename="manager-gui" />
    <user username="admin" password="admin" roles="manager-gui" />
```

### Tomcat manager remote access

Créer le fichier `/opt/tomcat/apache-tomcat-10.0.0-M1/conf/Catalina/localhost/manager.xml`

et y insérer les informations suivantes

```XML
<Context privileged="true" antiResourceLocking="false" 
    docBase="{catalina.home}/webapps/manager">
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />
</Context>
```

## Application 02

```shell
cp /home/dorian/appli01.zip /opt/tomcat/apache-tomcat-10.0.0-M1/webapps/
```

Puis dans le manager, renseigner la localisation du .war
