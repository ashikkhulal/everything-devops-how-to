#!/bin/bash

# jenkins rhel server provisioning script

sudo yum update -y
sudo yum install java -y
sudo yum install maven git wget unzip -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo firewall-cmd --permanent --service=jenkins --set-short="Jenkins Service Ports"
sudo firewall-cmd --permanent --service=jenkins --set-description="Jenkins service firewalld port exceptions"
sudo firewall-cmd --permanent --service=jenkins --add-port=8080/tcp
sudo firewall-cmd --permanent --add-service=jenkins
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
sudo systemctl restart jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword