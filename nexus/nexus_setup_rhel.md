# Nexus Setup:

**How to setup nexus on RHEL server:**

// install updates (optional):
    
    $ sudo yum update -y

// install java (alternatively, you can do $ sudo yum install java -y):

    $ sudo yum install java-1.8.0-openjdk.x86_64 -y

// install **wget**:

    $ sudo yum install wget -y

// create nexus directory in `opt` and `tmp`:

    $ mkdir -p /opt/nexus/
    $ mkdir -p /tmp/nexus/

// cd into `/tmp/nexus` directory:

    $ cd /tmp/nexus

// save `NEXUSURL` as a variable:

    $ NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"

// now, download nexus and save it into `nexus.tar.gz`:
    
    $ sudo wget $NEXUSURL -O nexus.tar.gz

// install nexus and save NEXUSDIR as a variable:

    $ EXTOUT=`tar xzvf nexus.tar.gz`
    $ NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`

// remove `nexus.tar.gz` file and synchronize `/opt/nexus` with `/tmp/nexus` location:

    $ sudo rm -rf /tmp/nexus/nexus.tar.gz
    $ sudo rsync -avzh /tmp/nexus/ /opt/nexus/

// add `nexus` user and give ownership of `/opt/nexus` to it:

    $ sudo useradd nexus
    $ sudo chown -R nexus.nexus /opt/nexus

// create a `nexus.service` file in `/etc/systemd/system` directory and insert following:

    $ sudo vim /etc/systemd/system/nexus.service
    Insert following (copy and paste) and save and quit (:wq):

    [Unit]                                                                          
    Description=nexus service                                                       
    After=network.target                                                            
                                                                    
    [Service]                                                                       
    Type=forking                                                                    
    LimitNOFILE=65536                                                               
    ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
    ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
    User=nexus                                                                      
    Restart=on-abort                                                                
                                                                    
    [Install]                                                                       
    WantedBy=multi-user.target

// run following command:

    $ sudo echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc

// reload daemon service, start nexus and enable on boot:

    $ systemctl daemon-reload
    $ systemctl start nexus
    $ systemctl enable nexus

// finally, verify on your browser:

    <your-vm-public-ip>:8081

// (optional) alternatively you can verify nexus status using following command:

    $ sudo systemctl status nexus