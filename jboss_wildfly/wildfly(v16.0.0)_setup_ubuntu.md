# **WILDFLY 16.0.0 Installation on UBUNTU 18.04 LTS:**

1. Install updates and upgrades:
    
        $ sudo apt-get update -y 
        $ sudo apt-get upgrade -y 

2. Install the OpenJDK package from APT:
    
        $ sudo apt-get install default-jdk -y

3. Create a user and group for wildfly:
    
        $ sudo groupadd -r wildfly
        $ sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly

4. Download the wildfly installation file:
    
        $ wget https://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz -P /tmp

5. Extract the wildfly tar.gz file to /opt folder:
    
        $ sudo tar xf /tmp/wildfly-16.0.0.Final.tar.gz -C /opt/

6. Create a symbolic link to point to the wildfly installation directory:
        
        $ sudo ln -s /opt/wildfly-16.0.0.Final /opt/wildfly

7. Give access to wildfly group and user:
    
        $ sudo chown -RH wildfly: /opt/wildfly

8. Configure wildfly to be run as a service:
        
        $ sudo mkdir -p /etc/wildfly
        $ sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
        $ sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/
        $ sudo sh -c 'chmod +x /opt/wildfly/bin/*.sh'
        $ sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
        $ sudo systemctl daemon-reload

9. Start wildfly service:
    
        $ sudo systemctl start wildfly
        $ sudo systemctl status wildfly         --- check status
        $ sudo systemctl enable wildfly         --- enable wildfly service at boot

10. Configure wildfly:
    
        $ sudo ufw allow 8080/tcp

11. Create a wildfly administrator:
        
        $ sudo /opt/wildfly/bin/add-user.sh
        Type of user: Management User 
        Username:
        Password:
        Group: none <hit enter>
        For option, if the user should be able to use the console remotely: yes

12. Now go to your local brower and enter your vm's public ip followed by colon and 8080 port to validate. (make sure you enable 8080 in NSG)

**Managing the Administrative console remotely:**

1. Edit the following config file:
        
        $ sudo vim /etc/wildfly/wildfly.conf
        
        Add the following lines to the end of the file:
        
        # The address console to bind to
        WILDFLY_CONSOLE_BIND=0.0.0.0  

2. Open the launch .sh script file through the following command:
        
        $ sudo vim /opt/wildfly/bin/launch.sh
        
        Change the WILDFLY_HOME (next to second if) and next to else to the following:
        
        $WILDFLY_HOME/bin/domain.sh -c $2 -b $3 -bmanagement $4

        else

        $WILDFLY_HOME/bin/standalone.sh -c $2 -b $3 -bmanagement $4

3.  Restart wildfly:
    
        $ sudo systemctl restart wildfly

4.  Finally, edit the wildfly.service file through the following command:
    
        $ sudo vim /etc/systemd/system/wildfly.service
        
        Change the ExecStart to following:
        
        ExecStart=/opt/wildfly/bin/launch.sh $WILDFLY_MODE $WILDFLY_CONFIG $WILDFLY_BIND $WILDFLY_CONSOLE_BIND

5.  Then, reload daemon and restart wildfly:
        
        $ sudo systemctl daemon-reload
        $ sudo systemctl restart wildfly

6.  Now go to your local brower and enter your vm's public ip followed by colon and 9990 port to validate. (make sure you enable 9990 in NSG)

**How to Open the Administrative Console CLI:**

1. Open your Ubuntu Terminal and switch to the /opt/wildfly/bin folder from where we will be running the CLI script:
    
        $ cd /opt/wildfly/bin/
        
2. Then, enter the following command to run WildFly Administrative Console CLI scrpit:
    
        $ ./jboss-cli.sh --connect
        Then, enter admin username and password.
        Enter "help" to see what all you can do here.