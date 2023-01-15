resource "aws_network_interface" "interface" {
  depends_on      = [module.vpc]
  subnet_id       = element(module.vpc.public_subnets, 0)
  private_ips     = [cidrhost(element(local.public_subnets, 0), 5)]
  security_groups = [aws_security_group.allow_tls.id]
}

resource "aws_instance" "ec2" {
  depends_on           = [aws_network_interface.interface]
  ami                  = data.aws_ami.amazon-linux-2.id
  instance_type        = local.instance_type
  user_data            = <<EOF
       #!/bin/bash

       #####JENKINS#######
       yum update -y
       wget -O /etc/yum.repos.d/jenkins.repo \
           https://pkg.jenkins.io/redhat-stable/jenkins.repo
       rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
       yum upgrade -y
       amazon-linux-extras install java-openjdk11 -y
       yum install jenkins git -y

       #######DOCKER############
       yum install -y docker
       systemctl start docker
       systemctl enable docker
       usermod -aG docker jenkins
       systemctl enable jenkins
       systemctl start jenkins
       
       ####KUBECTLandHELM######
       curl -LO https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl
       install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
       curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
       
       #####EKSCTL##############
       curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
       sudo mv /tmp/eksctl /usr/local/bin

       ######CONFIG########
       mkdir /var/lib/jenkins/.kube/
       cp ~/.kube/config /var/lib/jenkins/.kube/
       chown -R jenkins: /var/lib/jenkins/
       chmod 600 /var/lib/jenkins/.kube/config

       ######EKSCTL CLUSTER FILE###
        echo "
        apiVersion: eksctl.io/v1alpha5
        kind: ClusterConfig

        metadata:
          name: basic-cluster
          region: eu-central-1

        nodeGroups:
          - name: node1
            instanceType: t2.micro
            desiredCapacity: 2" > cluster.yaml
EOF
  key_name             = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.profile.name
  network_interface {
    network_interface_id = aws_network_interface.interface.id
    device_index         = 0
  }
}