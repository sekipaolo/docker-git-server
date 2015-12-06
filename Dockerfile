FROM alpine:edge

MAINTAINER Paolo Sechi <sekipaolo@gmail.com>
USER root

RUN apk --update add git openssh bash rsyslog
RUN addgroup git && adduser \
 -S  -s /bin/bash \
 -g 'User for managing of git version control' \
 -h /home/git \
 -D \
 git git
RUN passwd -u git
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key

WORKDIR /root
COPY sshd_config /etc/shh/sshd_config
COPY rsyslog.conf /etc/rsyslog.conf
#COPY keys/ /home/git/keys

COPY git.run run
RUN chmod +x run

RUN mkdir -p /home/git/.ssh && \
	touch /home/git/.ssh/authorized_keys  && \
	cat /home/git/keys/*.pub > /home/git/.ssh/authorized_keys  && \
	chown -R git:git /home/git/  && \
	chmod -R 700 /home/git/  

CMD /root/run