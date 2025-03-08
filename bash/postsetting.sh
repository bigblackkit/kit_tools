sudo apt-get install nano

sudo nano /etc/sudoers
kit ALL=(ALL:ALL) NOPASSWD: ALL

sudo nano /etc/netplan/50-cloud-init.yaml
sudo nano /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
network: {config: disabled}

sudo netplan generate
sudo netplan apply

sudo apt update && sudo apt install openvswitch-switch
sudo systemctl start ovsdb-server.service
sudo netplan apply

sudo nano /etc/hosts
192.168.0.80 k8s-master
192.168.0.81 k8s-worker
sudo nano /etc/hostname
sudo systemctl reboot
hostname
hostname -f


sudo apt-get update -y
sudo apt-get install -y iputils-ping
