#!/bin/bash

# nexus provisioning script on rhel server

sudo -i
yum install java-1.8.0-openjdk.x86_64 wget -y   
mkdir -p /opt/nexus/   
mkdir -p /tmp/nexus/                           
cd /tmp/nexus
NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
tar xvzf nexus.tar.gz -C /opt/nexus --strip-components=1
rm -rf /tmp/nexus/nexus.tar.gz
useradd nexus
chown -R nexus.nexus /opt/nexus 
cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]                                                                          
Description=nexus service                                                       
After=network.target                                                            
                                                                  
[Service]                                                                       
Type=forking                                                                    
LimitNOFILE=65536                                                               
ExecStart=/opt/nexus/bin/nexus start                                  
ExecStop=/opt/nexus/bin/nexus stop                                    
User=nexus                                                                      
Restart=on-abort                                                                
                                                                  
[Install]                                                                       
WantedBy=multi-user.target                                                      
EOT
systemctl daemon-reload
echo 'run_as_user="nexus"' > /opt/nexus/bin/nexus.rc
systemctl daemon-reload
systemctl start nexus
systemctl enable nexus