FROM centos:centos6
MAINTAINER ptro <ptro@centrum.cz>

# Setup Ansible to run localy
RUN yum -y install epel-release && yum install -y git subversion wget sudo ansible python openssh openssh-server openssh-clients && yum -y update
RUN useradd ansible && usermod -a -G root ansible && chmod g+w /var/log
RUN su - ansible -c "ssh-keygen -b 3072 -N '' -f /home/ansible/.ssh/id_rsa && cp /home/ansible/.ssh/id_rsa.pub /home/ansible/.ssh/authorized_keys && chmod 600 /home/ansible/.ssh/authorized_keys"
# ADD ansible/ansible /etc/sudoers.d/ansible
# ADD ansible/ansible.conf /etc/ansible/ansible.cfg
# ADD ansible/hosts /etc/ansible/hosts

# Following configuration should be really managed by ansible configuration
# from Git project rather than from this file.

# Install jenkins
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install java jenkins
RUN su - jenkins -c "ssh-keygen -b 3072 -N '' -f /var/lib/jenkins/.ssh/id_rsa"

# To start services when initialising docker container
ADD run_at_startup /usr/bin/run_at_startup
RUN echo "/usr/bin/run_at_startup" >> ~/.bashrc && chmod +x /usr/bin/run_at_startup
