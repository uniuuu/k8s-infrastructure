#!/bin/bash
set -o nounset -o errexit


CNI_VERSION="v0.8.2"
mkdir -p /opt/cni/bin
wget --no-check-certificate --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 -O- "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

CRICTL_VERSION="v1.16.0"
mkdir -p /opt/bin
wget --no-check-certificate --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 -O- "https://github.com/kubernetes-incubator/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /opt/bin -xz

RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"

mkdir -p /opt/bin
cd /opt/bin
wget --no-check-certificate --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}

curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
