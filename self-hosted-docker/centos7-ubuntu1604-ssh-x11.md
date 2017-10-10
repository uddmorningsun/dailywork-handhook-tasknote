According to related search or investigation, supporting sshd X11 in container have been finished in below two ways:

* `use SSH X11 Forwarding` for below Dockerfile following
* `use host-pc related X11-unix and DISPLAY variable`: use `docker` related arguments to map **X11-unix** and **DISPLAY** setting

For examples:
```
$ docker run -ti --rm --network host -v /tmp/.X11-unix/:/tmp/.X11-unix/  --env QT_QPA_PLATFORM=offscreen --env DISPLAY=$DISPLAY:unix centos:7.4.1708 /bin/bash
```

More info can refer to: https://github.com/jessfraz/dockerfiles     :+1:

```
FROM centos:7

RUN yum install -y epel-release && yum install -y sudo pssh openssh-server xorg-x11-xauth dbus libcanberra-gtk3 libcanberra-gtk2  PackageKit-gtk3-module wqy-zenhei-fonts && dbus-uuidgen > /var/lib/dbus/machine-id && echo "root:rootroot" | chpasswd

# http://www.ducea.com/2006/06/18/linux-tips-password-usage-in-sudo-passwd-nopasswd/
RUN ssh-keygen -A && sed -i "/#X11UseLocalhost/c X11UseLocalhost no" /etc/ssh/sshd_config && echo "Defaults   !authenticate" >> /etc/sudoers && echo "ALL     ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers
EXPOSE 22
CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D"]
```

```
FROM ubuntu:16.04

# https://stackoverflow.com/questions/40890011/ubuntu-dockerfile-mailutils-install
ENV DEBIAN_FRONTEND="noninteractive"

# https://major.io/2014/07/24/x11-forwarding-request-failed-on-channel-0/
RUN apt-get clean && apt-get update && apt-get install -y sudo pssh openssh-server packagekit-gtk3-module vim libcanberra-gtk-module libcanberra-gtk3-module language-pack-en-base dbus-x11 fonts-wqy-microhei && echo "AddressFamily inet" >> /etc/ssh/sshd_config && mkdir /var/run/sshd && echo "root:rootroot" | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && mkdir /root/.ssh && echo "Defaults   !authenticate" >> /etc/sudoers && echo "ALL     ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers
EXPOSE 22
CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D"]
```
