echo "Qwerty1" | sudo -S
clear
###################
#Описываем функции#
###################

#Настраиваем ДНС
function conf_dns {
if [[ $check_dns == "ISVN.local" ]]
then
	echo $GREEN"ДНС уже настроен!"$NOCOLOR
else
systemctl disable systemd-resolved.service > /dev/null 2>&1 && echo ""
systemctl stop systemd-resolved > /dev/null 2>&1 && echo ""
rm -rf /etc/resolv.conf

	echo $YELLOW"Настраиваем ДНС"$NOCOLOR
	echo "nameserver $mm_dns1
nameserver $mm_dns2
nameserver $mm_dns3
domain $mm_domain
search $mm_domain" > /etc/resolv.conf
	systemctl restart systemd-resolved
fi
}

#Настраиваем НТР
function conf_ntp {
if [[ $check_ntp == $mm_ntp ]]
then
	echo $GREEN"НТП уже настроен!"$NOCOLOR
else
	echo $YELLOW"Настраиваем НТП"$NOCOLOR
	sed -i "s/^#NTP=.*/NTP=$mm_ntp/g" /etc/systemd/timesyncd.conf
	systemctl restart systemd-timesyncd
	timedatectl set-timezone Europe/Moscow
fi
}

#Устанавливаем агент Касперского
function conf_klnagent {
if [[ $check_klnagent == "active" ]]
then
	echo $GREEN"Агент Каперского уже установлен!"$NOCOLOR
else
	echo $YELLOW"Устанавливаем агент Касперского"$NOCOLOR
	wget -q http://$repo_srv/klnagent64_$klnagent_ver.deb > /dev/null 2>&1 && echo $YELLOW"Скачиваем Агента Касперского"$NOCOLOR || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	echo "
	KLNAGENT_SERVER="$ksc_srv"
KLNAGENT_PORT="14000"
KLNAGENT_SSLPORT="13000"
KLNAGENT_USESSL="1"
KLNAGENT_GW_MODE="1"
	" > /tmp/klnagent.ini
	export KLAUTOANSWERS="/tmp/klnagent.ini"
	apt install ./klnagent64_$klnagent_ver.deb > /dev/null 2>&1 && echo $YELLOW"Устанавливаем и Настраиваем Агента Касперского"$NOCOLOR || echo $YELLOW"Ошибка! Нет какого файла"$NOCOLOR
	rm -rf ./klnagent64_$klnagent_ver.deb
fi
}

#Устанавливаем антивирус Касперского
function conf_kesl {
if [[ $check_kesl == "active" ]]
then
	echo $GREEN"Антивирус Касперского уже установлен!"$NOCOLOR
else
	echo $YELLOW"Устанавливаем антивирус Касперского"$NOCOLOR
	wget -q http://$repo_srv/kesl_$kesl_ver.deb > /dev/null 2>&1 && echo $YELLOW"Скачиваем Антивирус Касперского"$NOCOLOR || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	echo "EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
USE_GUI=no
UPDATE_EXECUTE=no
	" > /tmp/kesl.ini
	apt install ./kesl_$kesl_ver.deb > /dev/null 2>&1 && echo $YELLOW"Устанавливаем и настраиваем Антивирус Касперского"$NOCOLOR || echo $YELLOW"Ошибка! Нет какого файла"$NOCOLOR
	echo "Настраиваем антивирус Касперского" 
	/opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=/tmp/kesl.ini
	rm -rf ./kesl_$kesl_ver.deb
fi
}

function delete_kesl {
if [[ $check_kesl == "Unit" ]]
then
	echo $GREEN"Касперский уже удален!"$NOCOLOR
else
	echo $YELLOW"Удаляем касперского"$NOCOLOR
	sudo systemctl stop klnagent > /dev/null 2>&1 && sudo systemctl disable klnagent && echo $YELLOW"Удаляем Агента Касперского"$NOCOLOR
	sudo systemctl stop kesl > /dev/null 2>&1 && sudo systemctl disable klnagent && echo $YELLOW"Удаляет Антивирус Касперского"$NOCOLOR
	sudo dpkg -r klnagent64 > /dev/null 2>&1
	sudo dpkg -r kesl > /dev/null 2>&1
fi
}

#Копируем Лицензию
function conf_license {
if [[ $check_license == "licenseOS.txt" ]]
then
	echo $GREEN"Лицензия на месте!"$NOCOLOR
else
	echo $YELLOW"Копируем лицензию"$NOCOLOR
	wget -qP /home/ http://$repo_srv/licenseOS.txt > /dev/null 2>&1 && echo $YELLOW"Лицензия скопирована"$NOCOLOR || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
fi
}

#Настраиваем Заббикс агент для Терминала
function conf_zabbix_trm {
mkdir /var/log/zabbix-agent > /dev/null 2>&1 \
&& touch /var/log/zabbix-agent/zabbix_agentd.log \
&& chown zabbix:zabbix /var/log/zabbix-agent/zabbix_agentd.log \
&& systemctl restart zabbix-agent
sleep 3
if [[ $check_zbx_conf_trm == "ServerActive=$mm_zbx_srv" ]]
then
	echo $GREEN"Конфигурация Заббикс агента Терминала верна!"$NOCOLOR
else
	echo $YELLOW"Настраиваем заббикс агента для Терминала"$NOCOLOR
	sed -i "s/^Server=.*/Server=$mm_zbx_trm/g" /etc/zabbix/zabbix_agentd.conf 
	sed -i "s/^ServerActive=.*/ServerActive=$mm_zbx_trm/g" /etc/zabbix/zabbix_agentd.conf
fi
}

#Установка заббикс агента на терминала
function install_zbx_trm {
if [[ $check_zbx_trm == "active" ]]
then
	echo $GREEN"Заббикс Агент уже установлен на Терминале!"$NOCOLOR
else
	echo $YELLOW"Установка Заббикс Агент"$NOCOLOR
	wget http://$repo_srv/$zabbix_agent_trm > /dev/null 2>&1 && echo $YELLOW"Скачиваем Zabbix-Agent для терминала"$NOCOLOR || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	apt install ./$zabbix_agent_trm > /dev/null 2>&1
	rm -rf ./$zabbix_agent_trm
fi
}

#Установка заббикс агента на Видеосервер
function install_zbx_srv {
if [[ $check_zbx_srv == "active" ]]
then
	echo $GREEN"Заббикс Агент уже установлен на Видеосервере!"$NOCOLOR
else
	echo $YELLOW"Установка Заббикс Агент"$NOCOLOR
	wget http://$repo_srv/$zabbix_agent_srv > /dev/null 2>&1 && echo $YELLOW"Скачиваем Zabbix-Agent2 для Видеосервера"$NOCOLOR || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	apt install ./$zabbix_agent_srv
	rm -rf ./$zabbix_agent_srv
fi
}
#Настраиваем Заббикс агент для Видеосервера
function conf_zabbix_srv {
systemctl disable zabbix-agent > /dev/null 2>&1 && echo $YELLOW"Выключение Старой версии Zabbix-Agent"$NOCOLOR
systemctl stop zabbix-agent > /dev/null 2>&1
rm -rf /lib/systemd/system/zabbix-agent.service > /dev/null 2>&1 && rm -rf /etc/init.d/zabbix-agent > /dev/null 2>&1
systemctl daemon-reload
systemctl restart zabbix-agent2
if [[ $check_zbx_conf_srv == "ServerActive=$mm_zbx_srv" ]]
then
	echo $GREEN"Конфигурация заббикс агента Видеосервера верна!"$NOCOLOR
else
	echo $YELLOW"Настраиваем заббикс агента для Видеосервера"$NOCOLOR
	sed -i "s/^Server=.*/Server=$mm_zbx_srv/g" /etc/zabbix/zabbix_agent2.conf
	sed -i "s/^ServerActive=.*/ServerActive=$mm_zbx_srv/g" /etc/zabbix/zabbix_agent2.conf
fi
}

#Устанавливаем Вотчдог для терминала
function install_watchdog {
if [[ $check_wd == 'active' ]]
then
	echo $GREEN"Вотчдог уже установлен и настроен!"$NOCOLOR
elif [[ $check_wd == 'inactive' ]]
then
	echo $YELLOW"Активируем вотчдог"$NOCOLOR
	systemctl enable watchdog.service --now
else
	echo $YELLOW"Устанавливаем вотчдог на Терминал"$NOCOLOR
	wget -q http://$repo_srv/$wd.run > /dev/null 2>&1 && echo $YELLOW"Копируем watchdog" || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	bash ./$wd.run
	rm -rf ./$wd.run
fi
}

#Обновдяем УРПТ
function install_urpt {
#if [ $check_urpt = $urpt ]
#then
#	echo $GREEN"Установлена последняя Версия СПО Терминала"$NOCOLOR
#else
	rm -rf ./Skpt.Urpt_*
	echo $YELLOW"Обновляем УРПТ"$NOCOLOR
	wget -q http://$repo_srv/$urpt_latest > /dev/null 2>&1 && echo $YELLOW"Копируем обновление Urpt" || echo $YELLOW"Сервер Repo недоступен"$NOCOLOR
	bash ./$urpt_latest 2>&1
	rm -rf ./$urpt_latest
#fi
}

#Удалить все лишние репозитории на сервере
function update_all_repo {
echo $GREEN"Обновляем репозитории"$NOCOLOR
rm -rf /etc/apt/sources.list.d/*
rm -rf /etc/apt/sources.list
wget -qP /etc/apt/ http://10.251.70.86/sources.list 2>&1
apt update 2>&1
}


#Скорректировать apt.conf на сервере
function update_apt_confd {
echo $GREEN"Обновляем кофигурацию apt conf"$NOCOLOR
rm -rf /etc/apt/apt.conf.d/50appstream
wget -qP /etc/apt/apt.conf.d/ http://10.251.70.86/50appstream 2>&1
}

#Выключить ДХЦП на неиспользуемых интерфейсах на сервере
function turn_off_dhcp_eth {
#if (( $check_dhcp == "true" ))
#then
#	echo $GREEN"Интерфесы уже настроены!"$NOCOLOR
#else
echo $YELLOW"Убираем DHCP c не задействованных интерфейсов"$NOCOLOR
netplan set ethernets.eno7.optional=yes
netplan set ethernets.eno8.optional=yes
netplan apply
#fi
}

#Копируем и устанавливаем veeam на сервере
function install_veeam {
if (( $check_veeam == "active" ))
then
	echo $GREEN"Veeam уже установлен!"$NOCOLOR
else
	echo $YELLOW"Устанавливаем Veeam"$NOCOLOR
	wget http://10.251.70.86/veeam_snap.deb && wget http://10.251.70.86/veeam.deb 
	apt install cifs-utils -y
	apt install ./veeam_snap.deb -y && apt install ./veeam.deb -y
	rm -rf ./veeam_snap.deb
	rm -rf ./veeam.deb
fi
}

#Донастраиваем ИЛО
function conf_ilo {
cat > iloout1.cfg << EOF
<!-- HPONCFG VERSION = "5.5.0" -->
<!-- Device: iLO5  Firmware Version : 2.31 -->
<RIBCL VERSION="2.0">
  <LOGIN USER_LOGIN="admin" PASSWORD="password">

<RIB_INFO MODE="write"><LICENSE>
    <ACTIVATE KEY="3DTCH-H5462-S62G3-89S7H-7PHKW"/>
</LICENSE></RIB_INFO>

<RIB_INFO mode="write"><MOD_NETWORK_SETTINGS>
    <DNS_NAME VALUE="${old_hostname}IRC-01-iLO"/>
    <PRIM_DNS_SERVER VALUE="10.248.0.10"/>
    <SEC_DNS_SERVER VALUE="10.248.0.11"/>
    <TER_DNS_SERVER VALUE="10.248.0.12"/>
    <SNTP_SERVER1 VALUE="10.248.0.10"/>
</MOD_NETWORK_SETTINGS></RIB_INFO>

<DIR_INFO mode="write"><MOD_DIR_CONFIG>
    <DIR_AUTHENTICATION_ENABLED VALUE="Y"/>
    <DIR_ENABLE_GRP_ACCT VALUE="Y"/>
    <DIR_AUTHENTICATION_ENABLED VALUE="Y"/>
    <DIR_LOCAL_USER_ACCT VALUE="Y"/>
    <DIR_SERVER_ADDRESS VALUE="10.248.0.10"/>
    <DIR_SERVER_PORT VALUE="636"/>
    <DIR_GRPACCT3_NAME VALUE="CN=iLO-Administrators-OTI_SKPT,OU=Groups,OU=OTI_SKPT,OU=SKPT,OU=Metro_Departments,DC=ISVN,DC=local"/>
    <DIR_GRPACCT3_PRIV VALUE="1,2,3,4,5,6"/>
    <DIR_GRPACCT3_SID VALUE=""/>
</MOD_DIR_CONFIG></DIR_INFO>

<RIB_INFO mode="write"><MOD_SNMP_IM_SETTINGS>
    <SNMP_ADDRESS_1_ROCOMMUNITY VALUE="public"/>
</MOD_SNMP_IM_SETTINGS></RIB_INFO>

</LOGIN>
</RIBCL>
EOF
hponcfg -f iloout1.cfg
rm iloout1.cfg

}

function change_hostname {
echo $GREEN"Исправляем HOSTNAME!"$NOCOLOR
hostnamectl set-hostname $old_hostname"IRC-01"
new_hostname=$(hostname)
sed -i "/127.0.1.1/c 127.0.1.1 $new_hostname" /etc/hosts
}

#############################################
#Определяем глобальные переменные переменные#
#############################################
NOCOLOR=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
CIAN=$(tput setaf 6)
MAGENTA=$(tput setaf 5)
wd=$(wget -q -O - http://10.251.70.86 | grep -oh  "\w*watchdog\w*" | tail -1)
#urpt=$(wget -q -O - http://10.251.70.86 | grep -oh "\w*Skpt.Urpt_\w*" | tail -1 | tr -d \Skpt.Urpt_)
urpt_latest="Skpt.Urpt_2423069.run"
host_name=$(hostnamectl | grep Chassis | awk '{print $2}')
old_hostname=$(cut -c 1-8 /etc/hostname)
mm_dns1=10.248.0.10
mm_dns2=10.248.0.11
mm_dns3=10.248.0.12
mm_domain="ISVN.local"
mm_ntp=10.248.0.10
mm_zbx_srv="10.250.80.21,10.247.0.13"
mm_zbx_trm=10.250.80.21
repo_srv=10.251.70.86
ksc_srv=10.248.2.14
klnagent_ver="12.0.0-60_amd64"
kesl_ver="11.2.0-4528_amd64"
zabbix_agent_trm="zabbix-agent-trm.deb"
zabbix_agent_srv="zabbix-agent-srv.deb"
check_kesl=$(systemctl status kesl | grep active | awk '{print $2}') 2>&1
check_klnagent=$(systemctl status klnagent64 | grep active | awk '{print $2}') 2>&1
check_ntp=$(timedatectl timesync-status | grep 10.248.0.10 | awk '{print $2}') 2>&1
check_dns=$(cat /etc/resolv.conf | grep domain | awk '{print $2}') 2>&1
check_license=$(ls /home/ | grep license)


#######################
#Начало главного цикла#
#######################
if [ "${host_name}" == "desktop" ]
then
#####################################
#Определяем переменные для Терминала#
#####################################
check_zbx_trm=$(systemctl status zabbix-agent.service | grep running | awk '{print $2}') 2>&1
check_zbx_conf_trm=$(cat /etc/zabbix/zabbix_agentd.conf | grep  "^ServerActive=") 2>&1
check_wd=$(systemctl status watchdog.service | grep active | awk '{print $2}') 2>&1
check_urpt=$(cat /opt/Skpt.Urpt/Skpt.Urpt.App.deps.json | grep '"Skpt.Urpt.Common":' | tail -1 | awk '{print $2}' | tr -d \",.) 2>&1

	echo $BOLD $MAGENTA"
=====================================================
Производим автоматическую настрайку Теримнала для ПМИ
=====================================================
"$NOCOLOR
	conf_dns
	conf_ntp
	conf_license
	install_zbx_trm
	conf_zabbix_trm
	install_watchdog
	install_urpt
	conf_klnagent
	conf_kesl
else
########################################
#Определяем переменные для Видеосервера#
########################################
check_zbx_conf_srv=$(cat /etc/zabbix/zabbix_agent2.conf | grep  "^ServerActive=") 2>&1
check_zbx_srv=$(systemctl status zabbix-agent2.service | grep running | awk '{print $2}') 2>&1
check_veeam=$(systemctl status veeamservice.service | grep running | awk '{print $2}') 2>&1
check_dhcp=$(netplan get | grep "optional: true" | tail -1 | awk '{print $2}') 2>&1
	echo $BOLD $MAGENTA"
========================================================
Производим автоматическую настрайку Видеосервера для ПМИ
========================================================
"$NOCOLOR
	conf_dns
	conf_ntp
#	conf_klnagent
#	conf_kesl
	change_hostname
	delete_kesl
	conf_license
	install_zbx_srv
	conf_zabbix_srv
	update_apt_confd
	update_all_repo
	turn_off_dhcp_eth
	install_veeam
	conf_ilo
fi
echo $BOLD $MAGENTA"
========================================================
Настройка завершена, приступайте к проверке результатов!
========================================================
"$NOCOLOR

echo $BOLD $GREEN"
========================================================
Проверяем пинг до КТОСВН
========================================================
"$NOCOLOR
ping -c 4 ktosvn-edc
echo $BOLD $GREEN"
========================================================
Проверяем Настройку НТП
========================================================
"$NOCOLOR
timedatectl timesync-status
echo $BOLD $GREEN"
========================================================
Проверяем настройки ДНС
========================================================
"$NOCOLOR
cat /etc/resolv.conf

rm -rf auto_install.sh
