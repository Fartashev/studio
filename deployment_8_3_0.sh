#!/bin/bash


#### TES Deployment Automation ##########
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum -y install nodejs

echo -n "Which version of TES are you deploying now?  "
read ver

mkdir /appl/tes_$ver && cd /appl/tes_$ver
unzip /share/Software/TES/thingserver-8.3.0-b588.zip -d  /appl/tes_$ver
cd /appl/tes_$ver && npm install
chown -R twadmin:twadmin /appl/tes_$ver


#### Backup of Existing configuration.json file	#####
mv /appl/tes_$ver/configuration.json /appl/tes_$ver/configuration.json_bak


### Take Values	like Hostname, Domain, AppKey, RDS Hostname, TES Schema and Password ####

echo -n "Enter Hostname: "
read hostname
echo -n "Enter Domain URL (without https://): "
read URL
echo -n "Enter APPKey: "
read AppKey
echo -n "Enter RDS INFO WITH quotation mark   "
read RDSDB



##### Update This Values in the config File #####

cat > /appl/tes_$ver/configuration.json << EOF
{
 "port": 2019,
 "realm": "*",
 "httpsKeyPath": "",
 "httpsCrtPath": "",
 "httpsCaPath": "",
 "enable_irs_federation": true,
 "defaultDomainName": "$URL",
 "domain_id_resolver": "https://gxi.thingworx.io/ExperienceService/id-resolution/resolutions/",
 "dbHandler": "postgresHandler",
 "db": {
   "datafilePath": "./stores/db.sqlite",
   $RDSDB

 },
 "authentication": {
   "type": "twxUser",
   "baseUrl": "http://$hostname:8080",
   "authorization": {
     "appKey": "$AppKey",
     "refreshRate": "300000"
   }
 },
 "proxies": {
   "thingworx": {
     "target": "http://$hostname:8080/Thingworx",
     "autoRewrite": true,
     "protocolRewrite": "http",
     "secure": true,
     "appKey": "$AppKey",
     "blacklist": {
       "file": "proxyBlackList.json",
       "redirect": ""
     }
   }
 },
 "websocketProxies": {
   "thingworx": {
     "target": "ws://$hostname:8080"
   }
 },
 "projects": {
   "storePath": "./stores/projects",
   "staticOps": {
     "maxAge": "1 second"
   }
 },
  "reps": {
    "storePath": "./stores/reps",
    "staticOps": {
      "maxAge": "1 second",
      "index": [
        "structure.pvs"
      ]
    }
  },
  "upgrade": {
    "storePath": "./stores/upgrade"
  },
  "logsPath": "/var/log/thingserver.log*",
  "enableDatadog": true,
  "trustProxy": true

}



EOF

chown -R twadmin:twadmin /appl/tes_$ver
cd /appl
ln -s /appl/tes_$ver tes
cd /appl/tes
npm install -g forever
npm install -g forever-service
cd /appl/tes
/bin/forever-service install thingserver --script /appl/tes/server.js --scriptOptions "\-nossl" --foreverPath /bin --envVars NODE_ENV="production" --runAsUser twadmin
service thingserver start


echo "TES IS UP AND RUNNING NOW, ENJOY! :) "
