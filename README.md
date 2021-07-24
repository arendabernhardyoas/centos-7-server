# CentOS 7: Server

## Build a server with Linux CentOS 7

### Initial Config
Resize storage<br>
![resize-storage-1](./images/resize-storage-1.png)
`sudo rootfs-expand`
![resize-storage-2](./images/resize-storage-2.png)
`sudo reboot`<br>
Set up ip address network interface<br>
`nmtui`<br>
![nmtui-1](./images/nmtui-1.png)
![nmtui-2](./images/nmtui-2.png)
![nmtui-3](./images/nmtui-3.png)
![nmtui-4](./images/nmtui-4.png)
Verify connection<br>
`ping 8.8.8.8 -c 4`<br>
`ping youtube.com -c 4`<br>
![ping-internet](./images/ping-internet.png)
Update packages<br>
`sudo yum -y update`<br>
`sudo reboot`<br>
Install group package server with desktop environment<br>
`sudo yum groupinstall -y "Server with GUI"`<br>
`sudo reboot`<br>
GNOME desktop environment<br>
![gnome-desktop-environment](./images/gnome-desktop-environment.png)
Disable firewall<br>
`sudo systemctl stop firewalld`<br>
`sudo systemctl disable firewalld`<br>
Disable SELinux<br>
`sudo nano /etc/selinux/config`<br>
![selinux-config](./images/selinux-config.png)
`sudo reboot`<br>
Set up remote desktop vnc server<br>
`sudo yum install -y tigervnc-server`<br>
`vncserver :1`<br>
![vncserver](./images/vncserver.png)
`vncserver -kill :1`<br>
Set up remote desktop xrdp server<br>
`sudo yum --enablerepo=epel install -y xrdp`<br>
`sudo systemctl start xrdp`<br>
`sudo systemctl enable xrdp`<br>
`sudo reboot`<br>
Add additional repositories<br>
`sudo yum install -y epel-release`<br>
`sudo yum install -y centos-release-scl-rh centos-release-scl`<br>

### DNS Server
Install BIND<br>
`sudo yum install -y bind bind-utils`<br>
Configure BIND<br>
`sudo nano /etc/named.conf` [file](./configs/named.conf)<br>
![named-config-1](./images/named-config-1.png)
![named-config-2](./images/named-config-2.png)
Configure name resolution (forward lookup)<br>
`sudo nano /var/named/forward.arendabernhardyoas.com` [file](./configs/forward.arendabernhardyoas.com)<br>
![forward-lookup](./images/forward-lookup.png)
Configure address resolution (reverse lookup)<br>
`sudo nano /var/named/reverse.17.17.172` [file](./configs/reverse.17.17.172)<br>
![reverse-lookup](./images/reverse-lookup.png)
`sudo systemctl start named`<br>
`sudo systemctl enable named`<br>
Change DNS server network device<br>
`nmtui`
![named-nmtui-config](./images/named-nmtui-config.png)
`nmcli connection down Wired\ connection\ 1; nmcli connection up Wired\ connection\ 1`<br>
Additional configuration MikroTik router<br>
![router-dns-1](./images/router-dns-1.png)
Verify configurations<br>
![named-1](./images/named-1.png)
![named-2](./images/named-2.png)
![named-3](./images/named-3.png)
![router-dns-2](./images/router-dns-2.png)

### Web Server NGINX
Create new repository from [here](https://nginx.org/en/linux_packages.html)<br>
`sudo nano /etc/yum.repos.d/nginx.repo` [file](./configs/nginx.repo)<br>
![nginx-repo](./images/nginx-repo.png)
Install NGINX<br>
`sudo yum --enablerepo=nginx install -y nginx`<br>
Instal PHP and PHP-FPM<br>
`sudo yum --enablerepo=centos-sclo-rh install -y rh-php73-php rh-php73-php-mbstring rh-php73-php-pear rh-php73-php-fpm`<br>
Configurations<br>
`sudo scl enable rh-php73 bash`<br>
`sudo nano /etc/profile.d/rh-php73.sh`<br>
![nginx-php-config-1](./images/nginx-php-config-1.png)
`sudo systemctl start nginx rh-php73-php-fpm`<br>
`sudo systemctl enable nginx rh-php73-php-fpm`<br>
`sudo nano /etc/opt/rh/rh-php73/php-fpm.d/www.conf` [file](./configs/www.conf)<br>
![nginx-php-config-2](./images/nginx-php-config-2.png)
`sudo nano /etc/nginx/conf.d/default.conf` [file](./configs/default.conf)<br>
![nginx-config-1](./images/nginx-config-1.png)
![nginx-config-2](./images/nginx-config-2.png)
![nginx-config-3](./images/nginx-config-3.png)
`sudo chmod 755 -R /home/arendabernhardyoas`<br>
`sudo systemctl restart nginx rh-php73-php-fpm`<br>
Verify configurations<br>
![nginx-1](./images/nginx-1.png)
![nginx-2](./images/nginx-2.png)
![nginx-3](./images/nginx-3.png)
![nginx-4](./images/nginx-4.png)

### Database PostgreSQL
Create new repository from [here](https://www.postgresql.org/download/linux/redhat/)<br>
`sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-aarch64/pgdg-redhat-repo-latest.noarch.rpm`<br>
Install postgresql<br>
`sudo yum install -y postgresql11-server`<br>
Configure postgresql<br>
`sudo /usr/pgsql-11/bin/postgresql-11-setup initdb`<br>
`sudo systemctl start postgresql-11`<br>
`sudo systemctl enable postgresql-11`<br>
`sudo nano /var/lib/pgsql/11/data/postgresql.conf` [file](./configs/postgresql.conf)<br>
![postgresql-config-1](./images/postgresql-config-1.png)
![postgresql-config-2](./images/postgresql-config-2.png)
`nano /var/lib/pgsql/11/data/pg_hba.conf` [file](./configs/pg_hba.conf)<br>
![postgresql-config-3](./images/postgresql-config-3.png)
Adding address `0.0.0.0/0` can create postgresql connections from anywhere.<br>
Create postgresql superuser with unix user<br>
`sudo su - postgres`<br>
`createuser -s -i -d -r -l -w arendabernhardyoas`<br>
`psql -c "alter role arendabernhardyoas with password '<<password>>'"`<br>
`psql -c "alter role arendabernhardyoas with replication"`<br>
`psql -c "alter role arendabernhardyoas with bypassrls"`<br>
`exit`<br>
![postgresql-config-4](./images/postgresql-config-4.png)
Install PHP-PostgreSQL connector<br>
`sudo yum --enablerepo=centos-sclo-rh install -y rh-php73-php-pgsql`<br>
`sudo systemctl restart postgresql-11`<br>
Verify configurations<br>
![postgresql.png](./images/postgresql.png)

### Database MariaDB
Create new repository from [here](http://downloads.mariadb.org/mariadb/repositories/)<br>
`sudo nano /etc/yum.repos.d/mariadb.repo`<br>
![mariadb-repo](./images/mariadb-repo.png)
Install MariaDB<br>
`sudo yum --enablerepo=mariadb install -y MariaDB-server`<br>
Install PHP-MySQL connector<br>
`sudo yum --enablerepo=centos-sclo-rh install -y rh-php73-php-mysqlnd`<br>
`sudo systemctl start mariadb`<br>
`sudo systemctl enable mariadb`<br>
`sudo mariadb-secure-installation`<br>
![mariadb-config-1](./images/mariadb-config-1.png)
![mariadb-config-2](./images/mariadb-config-2.png)
`sudo systemctl restart mariadb`<br>
`sudo mariadb`<br>
`create user 'arendabernhardyoas'@'%' identified by '<<password>>';`<br>
`grant all privileges on *.* to 'aby'@'%' with grant option;`<br>
`flush privileges;`<br>
`\q`<br>
![mariadb-config-3](./images/mariadb-config-3.png)
Verify Configurations<br>
![mariadb](./images/mariadb.png)

### Samba
Install<br>
`yum -y install samba samba-client`<br>
Configure<br>
`nano /etc/samba/smb.conf` [file](./configs/smb.conf)<br>
`mkdir /home/public`<br>
`chmod 777 -R /home/public`<br>
`chown -R nobody:nobody /home/public`<br>
`systemctl start smb nmb`<br>
`systemctl enable smb nmb`<br>
Set password samba user with unix user<br>
`smbpasswd -a arendabernhardyoas`<br>
Verify configurations<br>
![samba](./images/samba.png)

### CUPS
Install CUPS<br>
`sudo yum install -y cups`<br>
`sudo nano /etc/cups/cupsd.conf` [file](./configs/cupsd.conf)<br>
`sudo systemctl start cups`<br>
`sudo systemctl enable cups`<br>
Create printer<br>
`sudo lpadmin -p printer-server -E -m drv:///sample.drv/laserjet.ppd -L "server arendabernhardyoas.com" -o printer-is-shared=true -v serial:/dev/ttyprintk?baud=1200+bits=8+parity=none+flow=none`<br>
`sudo systemctl restart cups smb nmb`<br>
Verify Configurations<br>
![cups-1](./images/cups-1.png)
![cups-2](./images/cups-2.png)
![cups-3](./images/cups-3.png)
![cups-4](./images/cups-4.png)
![cups-5](./images/cups-5.png)
![cups-6](./images/cups-6.png)
![cups-7](./images/cups-7.png)

### Mail Server
Install Postfix<br>
`sudo yum install -y postfix`<br>
Configure Postfix<br>
`sudo nano /etc/postfix/main.cf` [file](./configs/main.cf)<br>
![postfix-config-1](./images/postfix-config-1.png)
![postfix-config-2](./images/postfix-config-2.png)
![postfix-config-3](./images/postfix-config-3.png)
![postfix-config-4](./images/postfix-config-4.png)
![postfix-config-5](./images/postfix-config-5.png)
![postfix-config-6](./images/postfix-config-6.png)
![postfix-config-7](./images/postfix-config-7.png)
`sudo systemctl start postfix`<br>
`sudo systemctl enable postfix`<br>
Postfix run SMTP server on tcp port 25<br>
Install Dovecot<br>
`sudo yum install -y dovecot`<br>
Configure Dovecot<br>
`sudo nano /etc/dovecot/dovecot.conf` [file](./configs/dovecot.conf)<br>
![dovecot-config-1](./images/dovecot-config-1.png)
`sudo nano /etc/dovecot/conf.d/10-auth.conf` [file](./configs/10-auth.conf)<br>
![dovecot-config-2](./images/dovecot-config-2.png)
![dovecot-config-3](./images/dovecot-config-3.png)
`sudo nano /etc/dovecot/conf.d/10-mail.conf` [file](./configs/10-mail.conf)<br>
![dovecot-config-4](./images/dovecot-config-4.png)
`sudo nano /etc/dovecot/conf.d/10-master.conf` [file](./configs/10-master.conf)<br>
![dovecot-config-5](./images/dovecot-config-5.png)
`nano /etc/dovecot/conf.d/10-ssl.conf` [file](./configs/10-ssl.conf)<br>
![dovecot-config-6](./images/dovecot-config-6.png)
`sudo systemctl start dovecot`<br>
`sudo systemctl enable dovecot`<br>
Dovecot run POP service on tcp port 110 and IMAP on tcp port 143<br>
Configure mail account<br>
`sudo yum install -y mailx`<br>
`sudo nano /etc/profile`<br>
![mail-account-config](./images/mail-account-config.png)
`sudo systemctl restart postfix dovecot`<br>
Verify configurations<br>
![mail-1](./images/mail-1.png)
![mail-2](./images/mail-2.png)
![mail-3](./images/mail-3.png)
![mail-4](./images/mail-4.png)
![mail-5](./images/mail-5.png)
![mail-6](./images/mail-6.png)

### Web Server Apache
Install httpd (Apache)<br>
`yum -y install httpd`<br>
Configure httpd<br>
`nano /etc/httpd/conf/httpd.conf` [file](./configs/httpd.conf)<br>
![httpd-config-1](./images/httpd-config-1.png)
![httpd-config-2](./images/httpd-config-2.png)
`systemctl start httpd`<br>
`systemctl enable httpd`<br>
Install PHP<br>
`yum -y install php php-mbstring php-pear`<br>
Configure httpd user directory
`nano /etc/httpd/conf.d/userdir.conf` [file](./configs/userdir.conf)<br>
![userdir-httpd-config](./images/userdir-httpd-config.png)
`chmod 755 -R /home/arendabernhardyoas`<br>
`mkdir /home/mail`<br>
`chmod 755 -R /home/mail`<br>
`chown -R arendabernhardyoas:arendabernhardyoas /home/mail`<br>
Configure httpd SSL/TLS<br>
`yum -y install mod_ssl`<br>
`nano /etc/httpd/conf.d/ssl.conf` [file](./configs/ssl.conf)<br>
![ssl-httpd-config-1](./images/ssl-httpd-config-1.png)
![ssl-httpd-config-2](./images/ssl-httpd-config-2.png)
Configure httpd virtual host<br>
`nano /etc/httpd/conf.d/vhost.conf` [file](./configs/vhost.conf)<br>
![vhost-httpd-config](./images/vhost-httpd-config.png)
![ssl-vhost-httpd-config-1](./images/ssl-vhost-httpd-config-1.png)
![ssl-vhost-httpd-config-2](./images/ssl-vhost-httpd-config-2.png)
`systemctl restart httpd`<br>
Install SquirrelMail<br>
`yum --enablerepo=epel -y install squirrelmail`<br>
`curl -O http://www.squirrelmail.org/plugins/compatibility-2.0.16-1.0.tar.gz`<br>
`curl -O http://www.squirrelmail.org/plugins/empty_trash-2.0-1.2.2.tar.gz`<br>
`curl -O http://www.squirrelmail.org/plugins/secure_login-1.4-1.2.8.tar.gz`<br>
`tar zxvf compatibility-2.0.16-1.0.tar.gz -C /usr/share/squirrelmail/plugins`<br>
`tar zxvf empty_trash-2.0-1.2.2.tar.gz -C /usr/share/squirrelmail/plugins`<br>
`tar zxvf secure_login-1.4-1.2.8.tar.gz -C /usr/share/squirrelmail/plugins`<br>
`rm -f ./*.tar.gz`
Configure SquirrelMail<br>
`/usr/share/squirrelmail/config/conf.pl`<br>
![squirrelmail-config-1](./images/squirrelmail-config-1.png)
![squirrelmail-config-2](./images/squirrelmail-config-2.png)
![squirrelmail-config-3](./images/squirrelmail-config-3.png)
![squirrelmail-config-4](./images/squirrelmail-config-4.png)
![squirrelmail-config-5](./images/squirrelmail-config-5.png)
![squirrelmail-config-6](./images/squirrelmail-config-6.png)
`cp /usr/share/squirrelmail/plugins/secure_login/config.sample.php /usr/share/squirrelmail/plugins/secure_login/config.php`<br>
`nano /usr/share/squirrelmail/plugins/secure_login/config.php`<br>
![squirrelmail-config-7](./images/squirrelmail-config-7.png)
`nano /home/mail/index.php`<br>
![squirrelmail-webmail](./images/squirrelmail-webmail.png)
`systemctl restart httpd`<br>
Verify configurations<br>
![httpd-1](./images/httpd-1.png)
![httpd-2](./images/httpd-2.png)
![httpd-3](./images/httpd-3.png)
![httpd-4](./images/httpd-4.png)
![squirrelmail-1](./images/squirrelmail-1.png)
![squirrelmail-2](./images/squirrelmail-2.png)

### Other Config
Create SSL certificates self sign<br>
`cd /etc/pki/tls/certs`<br>
`make server.key`<br>
`openssl rsa -in server.key -out server.key`<br>
`make server.csr`<br>
`openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 365`<br>
![ssl](./images/ssl.png)

** **

**NOTE:**<br>
To get more CentOS 7 update packages using external repository and/or package download from official website is recommended<br>
Mirror download sources [here](http://isoredirect.centos.org/altarch/7/isos/aarch64/) CentOS Raspberry Pi inside folder `/images/` [example](https://mirror.papua.go.id/centos-altarch/7.9.2009/isos/aarch64/images).<br>
Raspberry Pi 4 ARM 64-bit 4GB RAM<br>
MikroTik RB941-2nD
