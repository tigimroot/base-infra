#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y
sudo yum install -y httpd
myip=`curl http://checkip.amazonaws.com`
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
sudo echo "Octarine server with IP: <h2>$myip</h2><br>" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
