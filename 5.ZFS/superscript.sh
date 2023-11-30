sudo -i
echo 'Смотрим список всех дисков, которые есть в виртуальной машине'
lsblk
echo 'Создадим 4 пула'
zpool create otus1 mirror /dev/sdb /dev/sdc
zpool create otus2 mirror /dev/sdd /dev/sde
zpool create otus3 mirror /dev/sdf /dev/sdg
zpool create otus4 mirror /dev/sdh /dev/sdi
echo 'Смотрим информацию о пулах'
zpool list
echo 'Добавим разные алгоритмы сжатия в каждую файловую систему'
zfs set compression=lzjb otus1
zfs set compression=lz4 otus2
zfs set compression=gzip-9 otus3
zfs set compression=zle otus4
echo 'Проверим, что все файловые системы имеют разные методы сжатия'
zfs get all | grep compression
echo 'Скачаем один и тот же текстовый файл во все пулы'
for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
echo 'Проверим, что файл был скачан во все пулы'
ls -l /otus*
echo 'Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов'
zfs list
zfs get all | grep compressratio | grep -v ref
echo 'Таким образом, у нас получается, что алгоритм gzip-9 самый эффективный по сжатию'
echo 'Определение настроек пула. Скачиваем архив в домашний каталог'
 wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
echo 'Распакуем архив'
tar -xzvf archive.tar.gz
echo 'Проверим, возможно ли импортировать данный каталог в пул'
zpool import -d zpoolexport/
echo 'Сделаем импорт данного пула к нам в ОС'
zpool import -d zpoolexport/ otus
zpool status
echo 'запрос сразу всех параметром файловой системы'
zpool get all otus
echo 'определить Размер'
zfs get available otus
echo 'определить тип'
zfs get readonly otus
echo 'определить значение recordsize'
zfs get recordsize otus
echo 'определить тип сжатия'
zfs get compression otus
echo 'определить тип контрольной суммы'
zfs get checksum otus
