#!/bin/bash
IPFIRST=192.168.1.1/24
IPSECOND=192.168.2.1/24
debug_flag=0
#работает если псоле параметра поставить = 
# команда проверка - bash serverB.sh --ip-first=192.168.1.2/24 --ip-second=192.168.2.2/24 
PARSED_ARGUMENTS=$(getopt -o f::,s::,d:: -l ip-first::,ip-second::,debug:: -n 'gateway.sh'  -- "$@")
#echo "$PARSED_ARGUMENTS"
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
    echo " Something wrong"
    exit 2
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
    case "$1" in
    --ip-first | -f) IPFIRST=$2; shift 2 ;;
    --ip-second | -s) IPSECOND=$2; shift 2 ;;
    --debug | -d) debug_flag=1; shift 2 ;;
    --) shift; break ;;
    *) echo "Unexpected option: $1 - this should not happen."
    exit 2 ;;
    esac
done
#echo "IPFIRST=$IPFIRST"
#echo "IPSECOND=$IPSECOND"

ip link add macvlan1 link eth0 type macvlan mode bridge # создаем новый адаптер с типом bridge и делаем связь адаптера с eth0 
ip address add dev macvlan1 $IPFIRST # добавляем ip адрес адаптеру
ip link set macvlan1 up # включаем адаптер

ip link add macvlan2 link eth0 type macvlan mode bridge # создаем новый адаптер с типом bridge и делаем связь адаптера с eth0 
ip address add dev macvlan2 $IPSECOND # добавляем ip адрес адаптеру
ip link set macvlan2 up # включаем адаптер

if [ "$debug_flag" == 1 ] 
then
echo "Назначеный ip адрес первому адаптеру шлюза $IPFIRST"
echo "Назначеный ip адрес второму адаптеру шлюза $IPSECOND"
echo " Все настроенные маршруты VM"
ip route show
echo " -------------------------------"
fi

docker run -v $PWD/mosquitto:/mosquitto/config -p 1883:1883 --name broker --rm eclipse-mosquitto