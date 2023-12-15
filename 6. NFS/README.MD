# **Задание**
Основная часть: 
- `vagrant up` должен поднимать 2 настроенных виртуальных машины (сервер NFS и клиента) без дополнительных ручных действий; - на сервере NFS должна быть подготовлена и экспортирована директория; 
- в экспортированной директории должна быть поддиректория с именем __upload__ с правами на запись в неё; 
- экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины (systemd, autofs или fstab -  любым способом); 
- монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3 по протоколу UDP; 
- firewall должен быть включен и настроен как на клиенте, так и на сервере. 

# **Ход работы и выводы команд**
```sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfss
Last login: Thu Nov 30 20:48:02 2023 from 10.0.2.2
[vagrant@nfss ~]$ sudo -i
[root@nfss ~]# yum install nano
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.linux-ia64.org
 * extras: mirror.linux-ia64.org
 * updates: ftp.nsc.ru
base                                                                | 3.6 kB  00:00:00
extras                                                              | 2.9 kB  00:00:00
updates                                                             | 2.9 kB  00:00:00
Package nano-2.3.1-10.el7.x86_64 already installed and latest version
Nothing to do
[root@nfss ~]# exit
logout
[vagrant@nfss ~]$ exit
logout
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant destroy --force
==> nfsc: Forcing shutdown of VM...
==> nfsc: Destroying VM and associated drives...
==> nfss: Forcing shutdown of VM...
==> nfss: Destroying VM and associated drives...
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant up
Bringing machine 'nfss' up with 'virtualbox' provider...
Bringing machine 'nfsc' up with 'virtualbox' provider...
==> nfss: Importing base box 'centos/7'...
==> nfss: Matching MAC address for NAT networking...
==> nfss: Checking if box 'centos/7' version '2004.01' is up to date...
==> nfss: There was a problem while downloading the metadata for your box
==> nfss: to check for updates. This is not an error, since it is usually due
==> nfss: to temporary network problems. This is just a warning. The problem
==> nfss: encountered was:
==> nfss:
==> nfss: The requested URL returned error: 404
==> nfss:
==> nfss: If you want to check for box updates, verify your network connection
==> nfss: is valid and try again.
==> nfss: Setting the name of the VM: dz6_nfss_1702373658144_87576
==> nfss: Clearing any previously set network interfaces...
==> nfss: Preparing network interfaces based on configuration...
    nfss: Adapter 1: nat
    nfss: Adapter 2: intnet
==> nfss: Forwarding ports...
    nfss: 22 (guest) => 2222 (host) (adapter 1)
==> nfss: Running 'pre-boot' VM customizations...
==> nfss: Booting VM...
==> nfss: Waiting for machine to boot. This may take a few minutes...
    nfss: SSH address: 127.0.0.1:2222
    nfss: SSH username: vagrant
    nfss: SSH auth method: private key
    nfss:
    nfss: Vagrant insecure key detected. Vagrant will automatically replace
    nfss: this with a newly generated keypair for better security.
    nfss:
    nfss: Inserting generated public key within guest...
    nfss: Removing insecure key from the guest if it's present...
    nfss: Key inserted! Disconnecting and reconnecting using new SSH key...
==> nfss: Machine booted and ready!
==> nfss: Checking for guest additions in VM...
    nfss: No guest additions were detected on the base box for this VM! Guest
    nfss: additions are required for forwarded ports, shared folders, host only
    nfss: networking, and more. If SSH fails on this machine, please install
    nfss: the guest additions and repackage the box to continue.
    nfss:
    nfss: This is not an error message; everything may continue to work properly,
    nfss: in which case you may ignore this message.
==> nfss: Setting hostname...
==> nfss: Configuring and enabling network interfaces...
==> nfss: Rsyncing folder: /home/sergey/dz6/ => /vagrant
==> nfsc: Importing base box 'centos/7'...
==> nfsc: Matching MAC address for NAT networking...
==> nfsc: Checking if box 'centos/7' version '2004.01' is up to date...
==> nfsc: Setting the name of the VM: dz6_nfsc_1702373694390_21607
==> nfsc: Fixed port collision for 22 => 2222. Now on port 2200.
==> nfsc: Clearing any previously set network interfaces...
==> nfsc: Preparing network interfaces based on configuration...
    nfsc: Adapter 1: nat
    nfsc: Adapter 2: intnet
==> nfsc: Forwarding ports...
    nfsc: 22 (guest) => 2200 (host) (adapter 1)
==> nfsc: Running 'pre-boot' VM customizations...
==> nfsc: Booting VM...
==> nfsc: Waiting for machine to boot. This may take a few minutes...
    nfsc: SSH address: 127.0.0.1:2200
    nfsc: SSH username: vagrant
    nfsc: SSH auth method: private key
    nfsc:
    nfsc: Vagrant insecure key detected. Vagrant will automatically replace
    nfsc: this with a newly generated keypair for better security.
    nfsc:
    nfsc: Inserting generated public key within guest...
    nfsc: Removing insecure key from the guest if it's present...
    nfsc: Key inserted! Disconnecting and reconnecting using new SSH key...
==> nfsc: Machine booted and ready!
==> nfsc: Checking for guest additions in VM...
    nfsc: No guest additions were detected on the base box for this VM! Guest
    nfsc: additions are required for forwarded ports, shared folders, host only
    nfsc: networking, and more. If SSH fails on this machine, please install
    nfsc: the guest additions and repackage the box to continue.
    nfsc:
    nfsc: This is not an error message; everything may continue to work properly,
    nfsc: in which case you may ignore this message.
==> nfsc: Setting hostname...
==> nfsc: Configuring and enabling network interfaces...
==> nfsc: Rsyncing folder: /home/sergey/dz6/ => /vagrant
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfss
[sudo] пароль для sergey:
[vagrant@nfss ~]$ sudo -i
[root@nfss ~]# yum install nfs-utils
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: mirror.hyperdedic.ru
 * extras: mirror.corbina.net
 * updates: mirror.hyperdedic.ru
base                                                                | 3.6 kB  00:00:00
extras                                                              | 2.9 kB  00:00:00
updates                                                             | 2.9 kB  00:00:00
(1/4): base/7/x86_64/group_gz                                       | 153 kB  00:00:00
(2/4): extras/7/x86_64/primary_db                                   | 250 kB  00:00:00
(3/4): updates/7/x86_64/primary_db                                  |  24 MB  00:00:07
(4/4): base/7/x86_64/primary_db                                     | 6.1 MB  00:00:11
Resolving Dependencies
--> Running transaction check
---> Package nfs-utils.x86_64 1:1.3.0-0.66.el7 will be updated
---> Package nfs-utils.x86_64 1:1.3.0-0.68.el7.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================
 Package             Arch             Version                      Repository         Size
===========================================================================================
Updating:
 nfs-utils           x86_64           1:1.3.0-0.68.el7.2           updates           413 k

Transaction Summary
===========================================================================================
Upgrade  1 Package

Total download size: 413 k
Is this ok [y/d/N]: y
Downloading packages:
No Presto metadata available for updates
warning: /var/cache/yum/x86_64/7/updates/packages/nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm is not installed
nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm                               | 413 kB  00:00:01
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-8.2003.0.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                                     1/2
  Cleanup    : 1:nfs-utils-1.3.0-0.66.el7.x86_64                                       2/2
  Verifying  : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                                     1/2
  Verifying  : 1:nfs-utils-1.3.0-0.66.el7.x86_64                                       2/2

Updated:
  nfs-utils.x86_64 1:1.3.0-0.68.el7.2

Complete!
[root@nfss ~]# systemctl enable firewalld --now
Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd/system/firewalld.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd/system/firewalld.service.
[root@nfss ~]# firewall-cmd --add-s
--add-service=      --add-source-port=  --add-source=
[root@nfss ~]# firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent
success
[root@nfss ~]# firewall-cmd --reload
success
[root@nfss ~]# systemctl enable nfs --now
Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/systemd/system/nfs-server.service.
[root@nfss ~]# ss -tnplu
Netid State      Recv-Q Send-Q Local Address:Port               Peer Address:Port
udp   UNCONN     0      0               *:931                         *:*                   users:(("rpcbind",pid=337,fd=7))
udp   UNCONN     0      0       127.0.0.1:974                         *:*                   users:(("rpc.statd",pid=3766,fd=5))
udp   UNCONN     0      0               *:2049                        *:*
udp   UNCONN     0      0               *:33031                       *:*                   users:(("rpc.statd",pid=3766,fd=8))
udp   UNCONN     0      0               *:48706                       *:*
udp   UNCONN     0      0       127.0.0.1:323                         *:*                   users:(("chronyd",pid=378,fd=5))
udp   UNCONN     0      0               *:68                          *:*                   users:(("dhclient",pid=2507,fd=6))
udp   UNCONN     0      0               *:20048                       *:*                   users:(("rpc.mountd",pid=3775,fd=7))
udp   UNCONN     0      0               *:111                         *:*                   users:(("rpcbind",pid=337,fd=6))
udp   UNCONN     0      0            [::]:59286                    [::]:*                   users:(("rpc.statd",pid=3766,fd=10))
udp   UNCONN     0      0            [::]:59041                    [::]:*
udp   UNCONN     0      0            [::]:931                      [::]:*                   users:(("rpcbind",pid=337,fd=10))
udp   UNCONN     0      0            [::]:2049                     [::]:*
udp   UNCONN     0      0           [::1]:323                      [::]:*                   users:(("chronyd",pid=378,fd=6))
udp   UNCONN     0      0            [::]:20048                    [::]:*                   users:(("rpc.mountd",pid=3775,fd=9))
udp   UNCONN     0      0            [::]:111                      [::]:*                   users:(("rpcbind",pid=337,fd=9))
tcp   LISTEN     0      64              *:2049                        *:*
tcp   LISTEN     0      64              *:35788                       *:*
tcp   LISTEN     0      128             *:111                         *:*                   users:(("rpcbind",pid=337,fd=8))
tcp   LISTEN     0      128             *:20048                       *:*                   users:(("rpc.mountd",pid=3775,fd=8))
tcp   LISTEN     0      128             *:22                          *:*                   users:(("sshd",pid=613,fd=3))
tcp   LISTEN     0      128             *:52087                       *:*                   users:(("rpc.statd",pid=3766,fd=9))
tcp   LISTEN     0      100     127.0.0.1:25                          *:*                   users:(("master",pid=829,fd=13))
tcp   LISTEN     0      64           [::]:2049                     [::]:*
tcp   LISTEN     0      64           [::]:44231                    [::]:*
tcp   LISTEN     0      128          [::]:111                      [::]:*                   users:(("rpcbind",pid=337,fd=11))
tcp   LISTEN     0      128          [::]:20048                    [::]:*                   users:(("rpc.mountd",pid=3775,fd=10))
tcp   LISTEN     0      128          [::]:36562                    [::]:*                   users:(("rpc.statd",pid=3766,fd=11))
tcp   LISTEN     0      128          [::]:22                       [::]:*                   users:(("sshd",pid=613,fd=4))
tcp   LISTEN     0      100         [::1]:25                       [::]:*                   users:(("master",pid=829,fd=14))
[root@nfss ~]# mkdir -p /srv/share/upload
[root@nfss ~]# chown -R nfsnobody:nfsnobody /srv/share
[root@nfss ~]# chmod 0777 /srv/share/upload
[root@nfss ~]# cat << EOF > /etc/exports
> /srv/share 192.168.56.11/32(rw,sync,root_squash)
> EOF
[root@nfss ~]# exportfs -r
[root@nfss ~]# exportfs -s
/srv/share  192.168.56.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
[root@nfss ~]#
 _______________client___________
 sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfsc
[vagrant@nfsc ~]$ sudo -i
[root@nfsc ~]# yum install nano
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: mirror.docker.ru
 * extras: ftp.nsc.ru
 * updates: ftp.nsc.ru
base                                                                | 3.6 kB  00:00:00
extras                                                              | 2.9 kB  00:00:00
updates                                                             | 2.9 kB  00:00:00
(1/4): base/7/x86_64/group_gz                                       | 153 kB  00:00:00
(2/4): extras/7/x86_64/primary_db                                   | 250 kB  00:00:01
(3/4): base/7/x86_64/primary_db                                     | 6.1 MB  00:00:04
(4/4): updates/7/x86_64/primary_db                                  |  24 MB  00:00:54
Resolving Dependencies
--> Running transaction check
---> Package nano.x86_64 0:2.3.1-10.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================
 Package           Arch                Version                     Repository         Size
===========================================================================================
Installing:
 nano              x86_64              2.3.1-10.el7                base              440 k

Transaction Summary
===========================================================================================
Install  1 Package

Total download size: 440 k
Installed size: 1.6 M
Is this ok [y/d/N]: y
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/nano-2.3.1-10.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for nano-2.3.1-10.el7.x86_64.rpm is not installed
nano-2.3.1-10.el7.x86_64.rpm                                        | 440 kB  00:00:00
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-8.2003.0.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : nano-2.3.1-10.el7.x86_64                                                1/1
  Verifying  : nano-2.3.1-10.el7.x86_64                                                1/1

Installed:
  nano.x86_64 0:2.3.1-10.el7

Complete!
[root@nfsc ~]# yum install nfs-utils.x86_64
Failed to set locale, defaulting to C
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.docker.ru
 * extras: ftp.nsc.ru
 * updates: ftp.nsc.ru
Resolving Dependencies
--> Running transaction check
---> Package nfs-utils.x86_64 1:1.3.0-0.66.el7 will be updated
---> Package nfs-utils.x86_64 1:1.3.0-0.68.el7.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===========================================================================================
 Package             Arch             Version                      Repository         Size
===========================================================================================
Updating:
 nfs-utils           x86_64           1:1.3.0-0.68.el7.2           updates           413 k

Transaction Summary
===========================================================================================
Upgrade  1 Package

Total download size: 413 k
Is this ok [y/d/N]: y
Downloading packages:
No Presto metadata available for updates
nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm                               | 413 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                                     1/2
  Cleanup    : 1:nfs-utils-1.3.0-0.66.el7.x86_64                                       2/2
  Verifying  : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                                     1/2
  Verifying  : 1:nfs-utils-1.3.0-0.66.el7.x86_64                                       2/2

Updated:
  nfs-utils.x86_64 1:1.3.0-0.68.el7.2

Complete!
[root@nfsc ~]# nano /etc/fstab
[root@nfsc ~]# nano /etc/fstab
[root@nfsc ~]# systemctl daemon-reload
[root@nfsc ~]# systemctl restart remote-fs.target
[root@nfsc ~]# mount | grep mnt
[root@nfsc ~]# systemctl enable firewalld --now
Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd/system/firewalld.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd/system/firewalld.service.
[root@nfsc ~]# mount | grep mnt
[root@nfsc ~]# systemctl daemon-reload
[root@nfsc ~]# systemctl restart remote-fs.target
[root@nfsc ~]# mount | grep mnt
[root@nfsc ~]# ls /mnt/
[root@nfsc ~]# nano /etc/fstab
[root@nfsc ~]# echo "192.168.56.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
[root@nfsc ~]# systemctl daemon-reload
[root@nfsc ~]# systemctl restart remote-fs.target
[root@nfsc ~]# mount | grep mnt
systemd-1 on /mnt type autofs (rw,relatime,fd=46,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=28279)
```
# **Проверка**
```sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfss
[sudo] пароль для sergey:
Попробуйте ещё раз.
[sudo] пароль для sergey:
Last login: Tue Dec 12 09:49:26 2023 from 10.0.2.2
[vagrant@nfss ~]$ sudo -i
[root@nfss ~]# cd /srv/share/upload/
[root@nfss upload]# touch check_file
[root@nfss upload]# exit
logout
[vagrant@nfss ~]$ exit
logout
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfsc
Last login: Tue Dec 12 09:59:24 2023 from 10.0.2.2
[vagrant@nfsc ~]$ sudo -i
[root@nfsc ~]# cd /mnt/upload/
[root@nfsc upload]# ls
check_file
[root@nfsc upload]# shutdown -r now
Connection to 127.0.0.1 closed by remote host.
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfsc
Last login: Tue Dec 12 10:37:34 2023 from 10.0.2.2
[vagrant@nfsc ~]$ cd /mnt/upload/
[vagrant@nfsc upload]$ ls
check_file
[vagrant@nfsc upload]$




2ч проверки
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfss
[sudo] пароль для sergey:
Попробуйте ещё раз.
[sudo] пароль для sergey:
Last login: Tue Dec 12 10:30:47 2023 from 10.0.2.2
[vagrant@nfss ~]$ sudo -i
[root@nfss ~]# shutdown -r now
Connection to 127.0.0.1 closed by remote host.
sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfss
Last login: Tue Dec 12 15:52:18 2023 from 10.0.2.2
[vagrant@nfss ~]$ sudo -i
[root@nfss ~]# cd /s
sbin/ srv/  sys/
[root@nfss ~]# cd /srv/share/upload/
[root@nfss upload]# ls
check_file
[root@nfss upload]# systemctl sta
start   status
[root@nfss upload]# systemctl status nfs
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: active (exited) since Tue 2023-12-12 15:53:08 UTC; 57s ago
  Process: 831 ExecStartPost=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)
  Process: 803 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS (code=exited, status=0/SUCCESS)
  Process: 799 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 803 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/nfs-server.service

Dec 12 15:53:08 nfss systemd[1]: Starting NFS server and services...
Dec 12 15:53:08 nfss systemd[1]: Started NFS server and services.
[root@nfss upload]# systemctl status firewalld.service
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2023-12-12 15:53:04 UTC; 1min 22s ago
     Docs: man:firewalld(1)
 Main PID: 407 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─407 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid

Dec 12 15:53:04 nfss systemd[1]: Starting firewalld - dynamic firewall daemon...
Dec 12 15:53:04 nfss systemd[1]: Started firewalld - dynamic firewall daemon.
Dec 12 15:53:05 nfss firewalld[407]: WARNING: AllowZoneDrifting is enabled. This is c...ow.
Hint: Some lines were ellipsized, use -l to show in full.
[root@nfss upload]# exportfs -s
/srv/share  192.168.56.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
[root@nfss upload]# showmount -a 192.168.56.10
All mount points on 192.168.56.10:
192.168.56.11:/srv/share
[root@nfss upload]#


sergey@sergey-INBOOK-X2-GEN11:~/dz6$ sudo vagrant ssh nfsc
Last login: Tue Dec 12 15:56:50 2023 from 10.0.2.2
[vagrant@nfsc ~]$ showmount -a 192.168.56.10
All mount points on 192.168.56.10:
[vagrant@nfsc ~]$ sudo -i
[root@nfsc ~]# cd /mnt/upload/
[root@nfsc upload]# ls
check_file
[root@nfsc upload]# mount | grep
Usage: grep [OPTION]... PATTERN [FILE]...
Try 'grep --help' for more information.
[root@nfsc upload]# mount | grep mnt
systemd-1 on /mnt type autofs (rw,relatime,fd=27,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=10906)
192.168.56.10:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.56.10,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.56.10)
[root@nfsc upload]# touch final_check
[root@nfsc upload]# ls
check_file  final_check

[root@nfss upload]# ls
check_file  final_check
[root@nfss upload]#
```
# **Заключение**
Развернут сервер и клиент NFS с общей папкой, проведено тестирование, всё отлично работает, данные действия автоматизированы с помощью двух скриптов, интегрированных в Vagrant файл
