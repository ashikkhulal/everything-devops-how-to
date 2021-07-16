# Jenkins Setup:

**How to setup jenkins on Ubuntu server:**

// install updates (optional):
    
    $ sudo apt update -y

// install java:

    $sudo apt install openjdk-8-jdk -y

// install **maven**, **git**, **wget** and **unzip**:

    $ sudo apt install maven git wget unzip -y

// get jenkins long-term release key:

    $ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

// add jenkins to apt-get repos:

    $ sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

// install updates again (optional):

    $ sudo apt-get update -y

// now, install jenkins:
    
    $sudo apt-get install jenkins -y

// start and enable jenkins:

    $ sudo systemctl start jenkins
    $ sudo systemctl enable jenkins

// finally, verify on your browser:

    <your-vm-public-ip>:8080

Note: jenkins initial password address is `/var/lib/jenkins/secrets/initialAdminPassword`. Run following command to view the initial password:

    $ sudo cat /var/lib/jenkins/secrets/initialAdminPassword