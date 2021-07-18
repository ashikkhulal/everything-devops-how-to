# Sonar Setup:

**How to setup sonar on Ubuntu server:**

// install updates (optional):
    
    $ sudo apt update -y

// we will edit `sysctl.conf` file but before that let's take a backup of it:

    $ cp /etc/sysctl.conf /root/sysctl.conf_backup

// let's append following texts in `sysctl.conf` file:

    $ sudo echo "vm.max_map_count=262144" >> /etc/sysctl.conf
    $ sudo echo "fs.file-max=65536" >> /etc/sysctl.conf
    $ sudo echo "ulimit -n 65536" >> /etc/sysctl.conf
    $ sudo echo "ulimit -u 4096" >> /etc/sysctl.conf

// verify the above lines has been added:

    $ sudo cat /etc/sysctl.conf

// now, we will edit `limits.conf` file but before that let's take a backup of it:

    $ cp /etc/security/limits.conf /root/sec_limit.conf_backup

// let's append following texts in `limits.conf` file:

    $ sudo echo "sonarqube   -   nofile   65536" >> /etc/security/limits.conf
    $ sudo echo "sonarqube   -   nproc    409" >> /etc/security/limits.conf

// verify the above lines has been added:

    $ sudo cat /etc/security/limits.conf

// install updates again (optional):

    $ sudo apt-get update -y

// install java 11 and configure the java:

    $ sudo apt-get install openjdk-11-jdk -y
    $ sudo update-alternatives --config java
    $ java -version

// now, get postgresql key:
    
    $ sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

// add the postgres in repos list and install postgres:

    $ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
    $ sudo apt install postgresql postgresql-contrib -y

// start and enable postgres:

    $ sudo systemctl start  postgresql.service
    $ sudo systemctl enable postgresql.service

// add the postgres in repos list and install postgres:

    $ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
    $ sudo apt install postgresql postgresql-contrib -y

// add postgres user and create sonar user for DB:

    $ sudo echo "postgres:admin123" | chpasswd
    $ sudo runuser -l postgres -c "createuser sonar"
    $ sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
    $ sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
    $ sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"

// restart postgres:

    $ sudo systemctl restart  postgresql

// create sonarqube directory and cd into it:

    $ sudo mkdir -p /sonarqube/
    $ cd /sonarqube/
    
// download sonarqube:

    $ sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip

// install zip:

    $ sudo apt-get install zip -y

// unzip downloaded sonarqube into `/opt/` directory:

    $ sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt/

// move to sonarqube directory inside /opt/:

    $ sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube

// add sonar group:

    $ sudo groupadd sonar

// add sonar group and make `/opt/sonarqube/` its home directory:

    $ sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar

// change ownership of `/opt/sonarqube` to sonar:

    $ sudo chown sonar:sonar /opt/sonarqube/ -R

// we will edit `sonar.properties` file but before that let's take a backup of it:

    $ cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup

// let's make following changes in `sonar.properties` file by doing `$ sudo vim /opt/sonarqube/conf/sonar.properties` and save and quit (:wq):

    sonar.jdbc.username=sonar
    sonar.jdbc.password=admin123
    sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
    sonar.web.host=0.0.0.0
    sonar.web.port=9000
    sonar.web.javaAdditionalOpts=-server
    sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
    sonar.log.level=INFO
    sonar.path.logs=logs

// now, we will add `sonarqube.service` file in `/etc/systemd/system/`:

    $ sudo vim /etc/systemd/system/sonarqube.service

// let's add following in `sonarqube.service` vim file and save and quit (:wq):

    [Unit]
    Description=SonarQube service
    After=syslog.target network.target
    [Service]
    Type=forking
    ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
    ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
    User=sonar
    Group=sonar
    Restart=always
    LimitNOFILE=65536
    LimitNPROC=4096
    [Install]
    WantedBy=multi-user.target

// now, let's reload daemon service and enable sonarqube:

    $ sudo systemctl daemon-reload
    $ sudo systemctl enable sonarqube.service

// now, let's install nginx and remove its default sites-enabled:

    $ sudo apt-get install nginx -y
    $ sudo rm -rf /etc/nginx/sites-enabled/default
    $ sudo rm -rf /etc/nginx/sites-available/default

// since we removed the default-sites availabe, let us add our own:
    
    $ sudo vim /etc/nginx/sites-available/sonarqube

    In the vim editor, copy and paste following and save and quit (:wq):

    server{
        listen      80;
        server_name sonarqube.groophy.in;
        access_log  /var/log/nginx/sonar.access.log;
        error_log   /var/log/nginx/sonar.error.log;
        proxy_buffers 16 64k;
        proxy_buffer_size 128k;
        location / {
            proxy_pass  http://127.0.0.1:9000;
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
            proxy_redirect off;
                
            proxy_set_header    Host            \$host;
            proxy_set_header    X-Real-IP       \$remote_addr;
            proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto http;
        }
    }

// let's link the nginx's sites-available to sites-enabled:

    $ ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube

// now, let's enable nginx on boot:

    $ sudo systemctl enable nginx.service

// let's open some ports:

    $ sudo ufw allow 80,9000,9001/tcp

// let's reboot the system for changes to take effect:

    $ reboot

// finally after 1 minute, verify on your browser:

    <your-vm-public-ip>

// (optional) alternatively you can verify sonarqube status using following command:

    $ sudo systemctl status sonarqube.service