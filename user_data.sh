#!/bin/bash
set -e -x

# Install HTTP Server to generate some traffic
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Welcome to Ansible automation of EC2 Intances-Yashsri.com</h1>" >> /var/www/html/index.html