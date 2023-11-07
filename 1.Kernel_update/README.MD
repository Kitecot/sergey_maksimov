# **Введение**

Выполнение действий приведенных в методичке позволит познакомиться с такими инструментами, как `Vagrant` и `Packer`, получить базовые навыки работы с системами контроля версий (`Github`). Получить навыки создания кастомных образов виртуальных машин и основам их распространения через репозиторий `Vagrant Cloud`. Так же вы получите навыки по обновлению ядра системы из репозитория.

Для выполнения работы потребуются следующие инструменты:

- **VirtualBox** - среда виртуализации, позволяет создавать и выполнять виртуальные машины;
- **Vagrant** - ПО для создания и конфигурирования виртуальной среды. В данном случае в качестве среды виртуализации используется *VirtualBox*;
- **Packer** - ПО для создания образов виртуальных машин;
- **Git** - система контроля версий

А так же аккаунты:

- **GitHub** - https://github.com/
- **Vagrant Cloud** - https://app.vagrantup.com


---
# Задание 1. Установить Vagrant, инициировать box через предоставленный Vagrantfile и обновить в нём ядро

# **Kernel update**

### **Клонирование и запуск**

Создадим Vagrantfile, в котором будут указаны параметры нашей ВМ:
### Описываем Виртуальные машины
  ```
MACHINES = {

  # Указываем имя ВМ "kernel update"
  :"kernel-update" => {
              #Какой vm box будем использовать
              :box_name => "generic/centos8s",
              #Указываем box_version
              :box_version => "4.3.4",
              #Указываем количество ядер ВМ
              :cpus => 2,
              #Указываем количество ОЗУ в мегабайтах
              :memory => 1024,
            }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    # Отключаем проброс общей папки в ВМ
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # Применяем конфигурацию ВМ
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
end
```
После создания Vagrantfile, запустим виртуальную машину командой vagrant up. Будет создана виртуальная машина с ОС CentOS 8 Stream, с 2-мя ядрами CPU и 1ГБ ОЗУ.

```
git clone git@github.com:<user_name>/manual_kernel_update.git
```

Теперь приступим к обновлению ядра.

### **kernel update**

Подключаемся по ssh к созданной виртуальной машины. Для этого в каталоге с нашим Vagrantfile вводим команду ``` vagrant ssh``` 
Перед работами проверим текущую версию ядра: ``
[vagrant@kernel-update ~]$ uname -r
4.18.0-277.el8.x86_64`` 


Подключаем репозиторий, откуда возьмем необходимую версию ядра.

``sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm``


В репозитории есть две версии ядер **kernel-ml** и **kernel-lt**. Первая является наиболее свежей стабильной версией, вторая это стабильная версия с длительной поддержкой, но менее свежая, чем первая. В данном случае ядро 6й версии будет в  **kernel-ml**.

Поскольку мы ставим ядро из репозитория, то установка ядра похожа на установку любого другого пакета, но потребует явного включения репозитория при помощи ключа ```--enablerepo```.

Ставим последнее ядро:

```
sudo yum --enablerepo elrepo-kernel install kernel-ml -y
```

### **grub update**
После успешной установки нам необходимо сказать системе, что при загрузке нужно использовать новое ядро. В случае обновления ядра на рабочих серверах необходимо перезагрузиться с новым ядром, выбрав его при загрузке. И только при успешно прошедших загрузке нового ядра и тестах сервера переходить к загрузке с новым ядром по-умолчанию. В тестовой среде можно обойти данный этап и сразу назначить новое ядро по-умолчанию. 

Обновляем конфигурацию загрузчика:
```
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```
Выбираем загрузку с новым ядром по-умолчанию:
```
sudo grub2-set-default 0
```

Перезагружаем виртуальную машину:
```
sudo reboot
```

После перезагрузки виртуальной машины (3-4 минуты, зависит от мощности хостовой машины) заходим в нее и выполняем:

```
uname -r
```

---


# Задание 2. Создать свой Vagrant box используя образ CentOS8, в собранном box-e должно быть ядро самой последней версии. Опубликовать box в Vagrant cloud, создать VagrantFile который будет разворачивать загруженный box

# **Packer**
Теперь необходимо создать свой образ системы, с уже установленым ядром 6й версии. Для это воспользуемся ранее установленной утилитой `packer`. В директории `packer` есть все необходимые настройки и скрипты для создания необходимого образа системы.

### **packer provision config**
Файл `centos.json` содержит описание того, как произвольный образ. Полное описание можно найти в документации к `packer`. 
```
#Основная секция, в ней указываются характеристики нашей ВМ
{"builders": [
    {
      #Указываем ссылку на файл автоматической конфигурации 
      "boot_command": [
 	"<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/vagrant.ks<enter><wait>"
],
      "boot_wait": "10s",
      #Указываем размер диска для ВМ
      "disk_size": "10240",
      "export_opts": [
        "--manifest",
        "--vsys",
        "0",
        "--description",
        "{{user `artifact_description`}}",
        "--version",
        "{{user `artifact_version`}}"
      ],
      #Указываем семейство ОС нашей ВМ
      "guest_os_type": "RedHat_64",
      #Указываем каталог, из которого возьмём файл автоматической конфигурации
      "http_directory": "http",
      #Контрольная сумма ISO-файла
      #Проверяется после скачивания файла
     "iso_checksum": "sha256:7d1967869643a66c83cedd5580cb45c0810ca9f6f47a8e36a8efbcf4824219a8",
      #Ссылка на дистрибутив из которого будет разворачиваться наша ВМ
      "iso_url": "https://mirror.linux-ia64.org/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso",
      #Hostname нашей ВМ
      #Имя ВМ будет взято из переменной image_name
      "name": "{{user `image_name`}}",
      "output_directory": "builds",
      "shutdown_command": "sudo -S /sbin/halt -h -p",
      "shutdown_timeout": "5m",
      #Пароль пользователя
      "ssh_password": "{{user `ssh_pass`}}",
      #Номер ssh-порта
      "ssh_port": 22,
      "ssh_pty": true,
      #Тайм-аут подключения по SSH
      #Если через 30 минут не получается подключиться, то сборка отменяется
      "ssh_timeout": "30m",
      #Имя пользователя
      "ssh_username": "vagrant",
      #Тип созданного образа (Для VirtualBox)
      "type": "virtualbox-iso",
      #Параметры ВМ
      #2 CPU и 1Гб ОЗУ
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "1024"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "2"
        ],
["modifyvm",
 "{{.Name}}",
 "--nat-localhostreachable1", "on"
]
      ],
      # Имя ВМ в VirtualBox
      "vm_name": "packer-centos-vm"
    }
  ],
  "post-processors": [
    {
      # Уровень сжатия
      "compression_level": "7",
      # Указание пути для сохранения образа
      # Будет сохранён в каталог packer
      "output": "centos-{{user`artifact_version`}}-kernel-6-x86_64-Minimal.box",
      "type": "vagrant"
    }
  ],
  # Настройка ВМ после установки
  "provisioners": [
    {
      "execute_command": "echo '{{user `ssh_pass`}}' |
{{.Vars}} sudo -S -E bash '{{.Path}}'",
      "expect_disconnect": true,
      "override": {
        "{{user `image_name`}}": {
          #Скрипты, которые будут запущены после установки ОС
          #Скрипты выполняются в указанном порядке
          "scripts": [
            "scripts/stage-1-kernel-update.sh",
            "scripts/stage-2-clean.sh"
          ]
        }
      },
      #Тайм-аут запуска скриптов, после того, как подключились по SSH
      "pause_before": "20s",
      "start_retry_timeout": "1m",
      "type": "shell"
    }
  ],
  #Указываем переменные
  #К переменным можно обращаться внутри данного JSON-файла
  "variables": {
    "artifact_description": "CentOS Stream 8 with kernel 6.x",
    "artifact_version": "8",
    "image_name": "centos-8stream"
"ssh_pass": "vagrant"
  }
}
```
### **packer build**
Для создания образа системы достаточно перейти в директорию `packer` и в ней выполнить команду:

```
packer build centos.json
```

Если все в порядке, то, согласно файла `config.json` будет скачан исходный iso-образ CentOS, установлен на виртуальную машину в автоматическом режиме, обновлено ядро и осуществлен экспорт в указанный нами файл. 

### **vagrant init (тестирование)**
Проведем тестирование созданного образа. Выполним его импорт в `vagrant`:

```
vagrant box add --name centos8-kernel6 centos-8-kernel-6-x86_64-Minimal.box 

```

Проверим его в списке имеющихся образов (ваш вывод может отличаться):

```
vagrant box list
centos8-kernel6   (virtualbox, 0)

```


Теперь необходимо провести тестирование полученного образа. 

```
vagrant init centos8-kernel6
```


Теперь запустим виртуальную машину, подключимся к ней и проверим, что у нас в ней новое ядро:

```
vagrant up
...
vagrant ssh    
```

и внутри виртуальной машины:

```
[vagrant@otus-c8 ~]$ uname -r
6.5.9-1.el8.elrepo.x86_64
[vagrant@otus-c8 ~]$ 

```


Удалим тестовый образ из локального хранилища:
```
vagrant box remove --force
```
---
# **Vagrant cloud**

Поделимся полученным образом с сообществом. Для этого зальем его в Vagrant Cloud. Можно залить через web-интерфейс, но так же `vagrant` позволяет это проделать через CLI.
Логинимся в `vagrant cloud`, указывая e-mail, пароль и описание выданого токена (можно оставить по-умолчанию)
```
vagrant cloud auth login
Vagrant Cloud username or email: <user_email>
Password (will be hidden): 
Token description (Defaults to "Vagrant login from ***"):
You are now logged in.
```
Теперь публикуем полученный бокс:
```
vagrant cloud publish --release <user_account>/centos8-kernel6 1.0 virtualbox centos-8-kernel-6-x86_64-Minimal.box

```
Здесь:
 - `cloud publish` - загрузить образ в облако;
 - `release` - указывает на необходимость публикации образа после загрузки;
 - `<username>/centos8-kernel6` - `username`, указаный при публикации и имя образа;
 - `1.0` - версия образа;
 - `virtualbox` - провайдер;
 - `centos-8-kernel-6-x86_64-Minimal.box` - имя файла загружаемого образа;

В результате создан и загружен в `vagrant cloud` образ виртуальной машины. Данный подход позволяет создать базовый образ виртульной машины с необходимыми обновлениями или набором предустановленного ПО. 
# **Заключение**

Результат выполнения ранее описанных действий по клонированию базового репозитория, созданию своего, создание кастомного образа с обновленным ядром и его публикация является необходимым для получения зачета по базовому домашнему заданию.  Одна часть залания со * выполнена - добавлением строчки в Vagrantfile (выложен в репозитории) в боксе создается папка otus_shared котороая будет являтся общей папкой с системой где была запущена коробка (общей папкой будлет являтся директория где инициирована коробка с Vagrantfile).
