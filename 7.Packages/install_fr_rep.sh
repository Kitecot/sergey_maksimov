echo "Перезапускаем nginx"
cd /root
cp /home/vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.spec
nginx -t
nginx -s reload
echo "Ставим МС из репо"
yum install -y mc-4.8.27-1.1.x86_64.rpm
