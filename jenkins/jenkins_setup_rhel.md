# Jenkins Setup:

**How to setup jenkins on RHEL server:**

// install updates (optional):
    
    $ sudo yum update -y

// install java (alternatively, you can do `$ sudo yum install java-1.8.0-openjdk -y` )

    $ sudo yum install java -y

// install **maven**, **git**, **wget** and **unzip**:

    $ sudo yum install maven git wget unzip -y

// add jenkins to apt-get repos:

    $ sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo

// import jenkins key:

    $ sudo rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key

// Now, install jenkins:

    $ sudo yum install jenkins -y

// start and enable jenkins:

    $ sudo systemctl start jenkins
    $ sudo systemctl enable jenkins

// (optional, only if you can't verify with next step, otherwise you can skip this step) configure your firewall:

    $ sudo firewall-cmd --permanent --service=jenkins --set-short="Jenkins Service Ports"
    $ sudo firewall-cmd --permanent --service=jenkins --set-description="Jenkins service firewalld port exceptions"
    $ sudo firewall-cmd --permanent --service=jenkins --add-port=8080/tcp
    $ sudo firewall-cmd --permanent --add-service=jenkins
    $ sudo firewall-cmd --zone=public --add-service=http --permanent
    $ sudo firewall-cmd --reload

// finally, verify it on your browser:

    <your-vm-public-ip>:8080

// (optional) alternatively you can verify jenkins status using following command:

    $ sudo systemctl status jenkins

Note: jenkins initial password address is `/var/lib/jenkins/secrets/initialAdminPassword`. Run following command to view the initial password:

    $ sudo cat /var/lib/jenkins/secrets/initialAdminPassword