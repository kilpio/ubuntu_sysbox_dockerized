FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    systemd systemd-sysv libsystemd0 ca-certificates iptables iproute2 dbus kmod locales sudo udev \
    apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    mc net-tools jq zip locales-all && \
    echo "ReadKMsg=0" >> /etc/systemd/journald.conf && \
    useradd --create-home --shell /bin/bash test && echo "test:test" | chpasswd && adduser test sudo \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && apt-get install --no-install-recommends -y \
        docker-ce docker-ce-cli containerd.io && \
    apt-get clean -y && \
    rm -rf \
        /var/cache/debconf/* \
        /var/lib/apt/lists/* \
        /var/log/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/doc/* \
        /usr/share/man/* \
        /usr/share/local/* && \
    usermod -a -G docker test 

RUN apt-get update && apt-get install --no-install-recommends -y \
            openssh-server &&  \
    mkdir /home/test/.ssh && \
    chown test:test /home/test/.ssh

EXPOSE 22

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
