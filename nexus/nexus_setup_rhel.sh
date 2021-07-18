#!/bin/bash

# nexus provisioning script on rhel server

sudo -i
yum install java-1.8.0-openjdk.x86_64 wget -y   
mkdir -p /opt/NEXUSHOME/   
mkdir -p /tmp/nexus/                           
cd /tmp/nexus
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
tar xvzf nexus.tar.gz
rm -rf /tmp/nexus/nexus.tar.gz
cp -R * /opt/NEXUSHOME/
cd /opt/NEXUSHOME/
mv nexus* nexus3
useradd nexus
chown -R nexus.nexus /opt/NEXUSHOME
cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]                                                                          
Description=nexus service                                                       
After=network.target                                                            
                                                                  
[Service]                                                                       
Type=forking                                                                    
LimitNOFILE=65536                                                               
ExecStart=/opt/NEXUSHOME/nexus3/bin/nexus start                                  
ExecStop=/opt/NEXUSHOME/nexus3/bin/nexus start                                    
User=nexus                                                                      
Restart=on-abort                                                                
                                                                  
[Install]                                                                       
WantedBy=multi-user.target                                                      
EOT
echo 'run_as_user="nexus"' > /opt/NEXUSHOME/nexus3/bin/nexus.rc
systemctl daemon-reload
systemctl start nexus.service
systemctl enable nexus.service