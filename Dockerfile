FROM quay.io/rockylinux/rockylinux:8

RUN dnf install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
  && dnf install -y \
  cvmfs \
  cvmfs-server \
  python3-mod_wsgi \
  cronie \
  xz \
  systemd \
  && dnf clean all

COPY cronjob /etc/cron.d/cronjob
COPY services/add-all-replicas.service /etc/systemd/system/add-all-replicas.service

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*; \
  systemctl enable httpd crond add-all-replicas

COPY scripts/cvmfs-add-all-replicas /usr/sbin/cvmfs-add-all-replicas
RUN chown root:root /usr/sbin/cvmfs-add-all-replicas \
  && chmod 700 /usr/sbin/cvmfs-add-all-replicas

VOLUME [ "/sys/fs/cgroup", "/srv/cvmfs", "/var/spool/cvmfs" ]

EXPOSE 80/tcp

ENTRYPOINT [ "/sbin/init" ]
