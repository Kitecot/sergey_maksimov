yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc pcre-devel
cd /root
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.20.2-1.el8.ngx.src.rpm
rpm -i nginx-1.*
wget https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz
tar -xvf openssl-1.1.1w.tar.gz
