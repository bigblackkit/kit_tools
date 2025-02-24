#!/bin/bash

echo "Wellcome to Installing GITLAB"

echo "Step1 : Add the GitLab package repository and install the package"
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

echo "Install Gitlab"
sudo EXTERNAL_URL="http://10.0.2.15" apt-get install gitlab-ce

#echo "Reconfigured Gitlab"
#sudo gitlab-ctl reconfigure

echo "Your Gitlab ROOT PASS"
sudo cat /etc/gitlab/initial_root_password

echo "Install Gitlab Done"