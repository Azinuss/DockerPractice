# Отчет по выполнению задания
## Создание скриптов с настройками docker
Создадим и настроим конфиг файл докер-образа

![image](assets\images\docker-conf.png)

Скомпилируем 
![image](assets\images\docker-build.png)

Зальем на docker-hub
![image](assets\images\build-push.png)

Сконфигурируем docker-compose файл симулятора ($SIM_HOST_IP переменная среды)

![image](assets\images\docker-compose_sim_conf.png)

Сконфигурируем docker-compose файл сервера

![image](assets\images\docker-compose_server_conf.png)

## Проверка работы локально
Запустим контейнер с mosquitto брокером (в результате запуска контейнера с симулятором датчика увидим подключение)
```shell
$ docker run -v $PWD/mosquitto:/mosquitto/config -p 1883:1883 --name broker --rm eclipse-mosquitto
```
![](assets\images\gateway-MMQT_local.png)
После запустим контейнер симулятора
```shell
$ docker run -e SIM_HOST=172.17.0.1 -e SIM_TYPE=temperature --name temperature azinus/sensor-sim
```
Проверим работу контейнера при помощи MMQT Exprorer
![](assets\images\MMQT-exprorer.png)

## Работа на виртуальной машине
Все файлы были скачаны на виртуальные машины при помощи команды 
```shell
$ git clone -b dev https://github.com/Azinuss/DockerPractice.git
```

### Сервер client
После запуска скрипта на виртуальной машине развернется три контейнера с разными симуляторами датчиков. Так же автоматически настроится ip route к серверу gateway

![](assets\images\Client_VM.png)

### Сервер gateway
После запуска срипта будет настроен путь к двум другим серверам, так же будет запущен контейнер с брокером 
![image](assets\images\gateway-MMQT_VM.png)

### Сервер server

После запуска скрипта будет настроен ip route а так же запущены три контейнера
![image](assets\images\ServerVM.png)

Проверим настройки базы данных в gafna 
![image](assets\images\DB_conf-check.png)

Создадим и настроим dashboard
![image](assets\images\Gafna-dashboard.png)

