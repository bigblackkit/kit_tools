# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# install packages
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl


# activate specific modules
# overlay — The overlay module provides overlay filesystem support, which Kubernetes uses for its pod network abstraction
# br_netfilter — This module enables bridge netfilter support in the Linux kernel, which is required for Kubernetes networking and policy.
sudo -i
modprobe br_netfilter
modprobe overlay


# enable packet forwarding, enable packets crossing a bridge are sent to iptables for processing
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf


# return to user
# In v1.22 and later, if the user does not set the cgroupDriver field under KubeletConfiguration, kubeadm defaults it to systemd.
# by default containerd set SystemdCgroup = false, so you need to activate SystemdCgroup = true, put it in /etc/containerd/config.toml
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cgroup-drivers
sudo mkdir /etc/containerd/
sudo vim /etc/containerd/config.toml

version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
   [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true

sudo systemctl restart containerd            


# get master ip for --apiserver-advertise-address
ip a


# to access kubernetes from external network you need to additionaly set flag with external ip --apiserver-cert-extra-sans=158.160.111.211
sudo kubeadm init \
  --apiserver-advertise-address=192.168.0.80 \
  --pod-network-cidr 10.244.0.0/16 \
  --apiserver-cert-extra-sans=10.0.2.15

# set default kubeconfig
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# add worker nodes
kubeadm token generate
kubeadm token create <generated-token> --print-join-command --ttl=0

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

#Cilium CLI
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

#Setup Helm repository:
helm repo add cilium https://helm.cilium.io/
#Deploy Cilium release via Helm:
helm install cilium cilium/cilium --version 1.17.1 \
  --namespace kube-system

cilium status --wait