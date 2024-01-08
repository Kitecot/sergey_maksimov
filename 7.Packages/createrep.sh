echo "сборка пакета"
cp /home/vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.spec
echo "установка nginx"
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm
echo "создание репозитория"
mkdir /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el8.ngx.x86_64.rpm  /usr/share/nginx/html/repo/
wget http://download.opensuse.org/repositories/home:/laurentwandrebeck:/mc/CentOS_7/x86_64/mc-4.8.27-1.1.x86_64.rpm -O /usr/share/nginx/html/repo/mc-4.8.27-1.1.x86_64.rpm


createrepo /usr/share/nginx/html/repo/
