# Switch to Root
sudo -i

# To update current packages and install all required
yum update -y
yum install lvm2 git vim wget httpd httpd-tools centos-release-scl mod_ssl php sysstat -y

# Default disk name is /dev/xvdb
# Create physical volume
pvcreate /dev/xvdb

# Create Virtual Group  
vgcreate myvir /dev/xvdb

# Create Logical Volume
lvcreate --name mypart --size 3.9G myvir

# Format the partition
mkfs.xfs /dev/mapper/myvir-mypart

# Create Directory /home2
mkdir /home2

# Mount the disk in home2
mount /dev/mapper/myvir-mypart /home2

# Add Entry in Fstab
# echo "" > /etc/fstab

# Create user blu with home directory /home2
useradd -b /home2 blu

# Delete blu password
passwd -d blu


ssh-keygen -N "" -f /home2/blu.ssh






# Create a new folder in blu user as public_html
mkdir /home2/blu/public_html

# Add Entry in fstab
echo "/dev/mapper/myvir-mypart /home2 xfs noexec" >> /etc/fstab

# Disable Selinux
setenforce 0

# Set LocatTime Zone
cd /etc
ln  -sf /usr/share/zoneinfo/Asia/Calcutta localtime

# Back to root
cd /root

# Download my motd file code
wget http://bit.ly/AkshayBenganimotd

# Rename it with motd.sh
mv AkshayBenganimotd motd.sh

# Give permissions to motd file
chmod +x motd.sh

# Add motd to bashrc and update that
echo "./motd.sh" >> .bashrc
source .bashrc

# Start and enable httpd service
systemctl start httpd
systemctl enable httpd

# Set apache on
apachectl graceful

# Switch to conf.d
cd /etc/httpd/conf.d

# Add config file in /etc/httpd/conf.d
echo "<VirtualHost *:80>
>   ServerName bluboy.adhocnw.com
>   ServerAlias www.bluboy.adhocnw.com
>   ServerAdmin webmaster@bluboy.adhocnw.com
>   DocumentRoot /home2/blu/public_html
>
>   <Directory /home2/blu/public_html>
>       Options -Indexes +FollowSymLinks
>       AllowOverride All
>   </Directory>
>
>   ErrorLog /var/log/httpd/blu-adhocnw.com-error.log
>   CustomLog /var/log/httpd/blu-adhocnw.com-access.log combined
> </VirtualHost>" >blu-php.conf

# Create files for error log and access log
touch /var/log/httpd/blu-adhocnw.com-error.log
touch /var/log/httpd/blu-adhocnw.com-access.log

# Set configuration
apachectl configtest

# Restart httpd service
systemctl restart httpd

# Create index.html file
echo "<h1> Warmup Task Completed Partially </h1>" > /var/www/html/index.html

