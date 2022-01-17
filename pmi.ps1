Clear-Host
#Глобальные переменные
Write-Host "==Коллеги, добро пожаловать на удаленное ПМИ===
Для работы скрипта необхомидо отпределеить глобальные переменные
"
$ip_station = Read-Host "Введите первые 3 октета станции (пример 10.0.0)"
$station_code = Read-Host "Введите цифровой код станции (пример 06-01)"
$ip_string_to_array = $ip_station.Split(".")
$ip_cam_array_to_string = $ip_string_to_array[0,1] + ($ip_string_to_array[2] - 1)
$ip_cams = $ip_cam_array_to_string -join "."
$cams_nums_user = Read-Host "Введите кол-во Видеокамер согласно ЭТ"
$post_nums_user = Read-Host "Введите кол-во постов" 
$all_func = (Get-ChildItem function:\ | Where-Object {$_.Name -like "step*"}).Name
$ilos_array = 130,131







#Открывается экплорер и вводим адрес \\10.250.80.30\skpt_backup п.7.1.1

function step070101 {
Clear-Host
Write-Host  "Пункт 7.1.1 в части 2
-	выполняется предъявление Подрядчиком резервной копии настроек и операционных систем ОУ СКПТ, сохраненной на физическом носителе;
-	с помощью ноутбука выполняется предъявление загрузки с физического носителя и автоматического запуска программного обеспечения восстановления системы;
-	выполняется подтверждение наличия резервной копии настроек и операционных систем ОУ СКПТ в формате электронного образа восстановления системы;
-	выполняется визуальная проверка названия образа восстановления системы и даты формирования образа

Проверяем содержимое \\10.250.80.30\skpt_backup
"
explorer \\10.250.80.30\skpt_backup
$check = Read-Host "Пункт 7.1.1 в части 2 пройден? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}

Stop-Process -Name explorer -ErrorAction Ignore
}
#Открывает ИП сканер и вводим необходимый диапазон

function step070102 {
Clear-Host
Write-Host "7.1.2	Порядок проведения испытаний:
-	с помощью утилиты «ping» проверить доступность IP устройств, подключенных в сеть управления СКПТ (в соответствии с эксплуатационной таблицей);
-	с помощью утилиты «ping» проверить доступность IP устройств, подключенных в сеть данных СКПТ в соответствии с эксплуатационной таблицей);
-	с помощью утилиты «ping» проверить доступность IP устройств, подключенных в сеть телекамер СКПТ (в соответствии с эксплуатационной таблицей);
-	с помощью утилиты «ping» проверить доступность IP рабочего места Комплекса технического обслуживания систем видеонаблюдения (10.247.128.47), расположенного в ПУОТБ (в соответствии с ЭТ).
"
ping 10.247.128.47
ping $ip_station".129"
Start-Sleep -Seconds 5
Start-Process -FilePath 'C:\Program Files (x86)\Advanced IP Scanner\advanced_ip_scanner.exe'
$check = Read-Host "Пункт 7.1.2 Кол-во и ИП оборудования совпадает с ЭТ? Пункт пройден? (Y\N)
[0] Возврат к выбору пункта ПМИ "
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name Advanced* -force -ErrorAction Ignore
}
#В браузере открывает все доступные по веб морде устройства
function step070103 {
Clear-Host
Write-Host "Пункт 7.1.3
-	с помощью ноутбука, осуществить вход на сервер СКПТ по сервису ILO с использованиеv логина/пароля из эксплуатационной таблицы;
-	осуществить подключение к коммутаторам с использованием логина/пароля из эксплуатационной таблицы;
-	осуществить подключение через web-интерфейс к настройкам телекамер с использованиеv логина/пароля из эксплуатационной таблицы, проверить заданное имя камеры.
"
Write-Host "Выполняем подключение к устройствам в браузере"
foreach ($ilo_array in $ilos_array){
    $urls = @("http://$ip_station.$ilo_array")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }

$lantans_array = 1..$post_nums_user
foreach ($post_nums_user in $lantans_array){
    $lantan_num = $post_nums_user + 136
    $urls = @("http://$ip_station.$lantan_num")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }

& "C:\Program Files\Google\Chrome\Application\chrome.exe" "$ip_station.250"
Start-Sleep -Seconds 2

$cams_array = 1..$cams_nums_user
foreach ($cam_num_user in $cams_array){
    $cam_num = $cam_num_user + 128
    $urls = @("http://$ip_cams.$cam_num")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 1}
        }
#putty "$ip_station.129"
#putty "$ip_station.194"
#putty "$ip_station.195"
#mstsc /v:$ip_station.211 /prompt

$check = Read-Host "С камерами и настройками камер все ок? Пункт пройден? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}
#Вывод окна с актикацией
function step070105 {
Clear-Host
Write-Host "Пункт 7.1.5
Проверка лицензионных ключей программного обеспечения ОУ СКПТ. Проверка выполняется для подтверждения количественного и качественного состава программного обеспечения, 
функционирующего в составе ОУ СКПТ. Проверка выполняется для всего комплекса ОУ СКПТ. Для сверки применяются исходные данные о количественном и качественном составе 
программного обеспечения ОУ СКПТ, указанные в следующих документах: исполнительная документация, эксплуатационная таблица, сертификаты на программное обеспечение 
(в том числе данные, указанные на лицензионных наклейках поставщиков программного обеспечения в случае их наличия).
"
slmgr /dli
& "C:\Program Files (x86)\Kaspersky Lab\Kaspersky Endpoint Security for Windows\avpui.exe"
putty "$ip_station.194"
putty "$ip_station.195"
mstsc /v:$ip_station.193 /prompt
$check = Read-Host "Пункт 7.1.5 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}
#Сервиса заббикс

function step070106 {
Clear-Host
Write-Host "Пункт 7.1.6 Проверка сервисов мониторинга состояния системы проводится для подтверждения фактического наличия и функционирования данных сервисов в соответствия требованиями проектной документации. Проверке подлежат:
-	сервер видеонаблюдения (операционная система семейства «Linux» («Ubuntu»));
-	АПК «Объектовый сервер» (операционная система «Windows»);
-	АРМ «Объект» (операционная система «Windows»);
-	ПАК УРПТ(операционная система семейства «Linux» («Ubuntu»)).
"
service "Zabbix Agent 2"
putty "$ip_station.194"
putty "$ip_station.195"
mstsc /v:$ip_station.193 /prompt

$check = Read-Host "Пункт 7.1.6 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}

function step070107 {
Clear-Host
Write-Host "Пункт 7.1.7 Проверка статуса сервиса менеджмента серверов ПАК ОУ СКПТ:
−	В сервисе ILO осуществить вход в раздел «Активация», считать полученный лицензионный ключ;
−	Выполнить сверку лицензионного ключа, полученного в разделе «Активация», с лицензионным ключом, полученным в личном кабинете производителя;
"
foreach ($ilo_array in $ilos_array){
    $urls = @("http://$ip_station.$ilo_array")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }

$check = Read-Host "Пункт 7.1.7 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}


#Проверка АД\Ралиус, где можно
function step070108 {
Clear-Host
Write-Host "Пункт 7.1.8 Проверка авторизации на серверном оборудовании ПАК ОУ СКПТ с помощью учетной записи Active Directory
	С помощью учетной записи «a_beznos@ISVN.local» последовательно осуществить авторизацию на серверном оборудовании, 
коммутаторах и в менеджменте серверов ПАК ОУ СКПТ.
"
mstsc /v:$ip_station.193 /prompt
#mstsc /v:$ip_station.211 /prompt
putty "$ip_station.129"
foreach ($ilo_array in $ilos_array){
    $urls = @("http://$ip_station.$ilo_array")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "$ip_station.250"
$check = Read-Host "Пункт 7.1.8 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}

#Проверяем везде ДНС
function step070109 {
Clear-Host
Write-Host "Пункт 7.1.9 Проверка корректности настройки DNS ПАК ОУ СКПТ
	с помощью ноутбука, осуществить вход на сервер ПАК ОУ СКПТ с использованием логина/пароля из эксплуатационной таблицы;
	с помощью утилиты «ping» по имени хоста проверить доступность устройств, подключенных в сеть управления СКПТ – ЕАВ и ЦУ (в соответствии с эксплуатационной таблицей);
	с помощью утилиты «ping» по имени хоста проверить доступность рабочего места Комплекса технического обслуживания систем видеонаблюдения (ktosvn-edc), расположенного в ПУОТБ (в соответствии с эксплуатационной таблицей).

"
ping ktosvn-edc
ping $station_code"-S-SKPT-01"
ping $station_code"-S-SKPT-02"
ping $station_code"-ARM-01"
ping $station_code"-TRM-01"
mstsc /v:$ip_station.193 /prompt
#mstsc /v:$ip_station.211 /prompt
putty "$ip_station.129"
putty "$ip_station.194"
putty "$ip_station.195"
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "$ip_station.250"
$check = Read-Host "Пункт 7.1.9 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}

function step070110 {
Clear-Host
Write-Host "Пункт 7.1.10
Проверка работоспособности видеорегистрации ПАК ОУ СКПТ
"
try {
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "$ip_station.194:9200"
}
finally {
& "C:\Program Files\Mozilla Firefox (x86)\firefox.exe" "$ip_station.194:9200"
}
Clear-Host
#Расчет формулы видеоархива
Write-Host "Сейчас будет запрос переменных для формулы расчета места видео архива"
$var_d_u = Read-Host "«D» - длительность сохраненного фрагмента в секундах (указываем в минутах, формат XX:XX)"
$var_d_s = $var_d_u.Split(":")
$var_d = (([int]$var_d_s[0]*60)+[int]$var_d_s[1])
Write-Host "«D» - длительность сохраненного фрагмента в секундах: $var_d секунд"
$var_v_u = Read-Host "«V» – размер сохраненного фрагмента в мегабайтах (указываем в Килобайтах, формат : 310000"
$var_v = [int]$var_v_u/1024
Write-Host "«V» – размер сохраненного фрагмента в мегабайтах: $var_v мегабайта"
$var_s_u = Read-Host "«S» – общий объем разделов хранилища видеоданных сервера видеорегистрации СКПТ в мегабайтах (указываем в гигабайтах, формат: 14900)"
$var_s = ([int]$var_s_u*1024)
Write-Host "«S» – общий объем разделов хранилища видеоданных сервера видеорегистрации СКПТ в мегабайтах: $var_s мегабайт"
$var_n = Read-Host "«N» - общее количество видеокамер ОУ СКПТ согласно требованиям проектной документации. Ранее было: $cams_nums_user"
$var_t_s = ([int]$var_s/([int]$var_v/(([int]$var_d*[int]$var_n))))
$var_t_m = [int]$var_t_s/60
$var_t_h = [int]$var_t_m/60
$var_t_d = [int]$var_t_h/24
Write-Host "Выполняем расчет расчет времени хранения («Т») по следующей формуле: T=S / (V / D * n)"
Write-Host "«Т секунды»= $var_t_s секунд"
Write-Host "«Т минуты»= $var_t_m минут"
Write-Host "«Т часы»=  $var_t_h часов"
Write-Host "«Т дни»= $var_t_d дней"

$check = Read-Host "Пункт 7.1.10 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}
#Проверка железа на серверах через ilo
function step070111 {
Clear-Host
Write-Host "Пункт 7.1.11,12 Проверка комплектации сервера видеонаблюдения и АПК «Объектовый сервер» ОУ СКПТ

"
foreach ($ilo_array in $ilos_array){
    $urls = @("http://$ip_station.$ilo_array")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }
$check = Read-Host "Пункт 7.1.11,12 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}
function step070307 {
Clear-Host
Write-Host "Пункт 7.3.7 Контроль срабатывания УКПТ на подвижной состав
Порядок проведения испытаний: Проезд подвижного состава или хозяйственной единицы через зону контроля прохода в тоннель с любой скоростью в любом направлении
"
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://$ip_station.193"
$check = Read-Host "Пункт 7.3.7 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}

#
function step070309 {
Clear-Host
Write-Host "Пункт 7.3.9,10
7.3.9. Проверка функционирования телекамер:
	через web-интерфейс проверить заводские номера телекамер;
	проверить заданное имя телекамеры;
	проверить сетевые параметры телекамеры;
	проверить настройки потоков HD и SD телекамеры;
	проверить работу двух мультикаст потоков одновременно;
	провести сверку полученных результатов с проектными значениями;

7.3.10. Проверка зон обзора телекамер:
	через специализированное программное обеспечение выполнить удаленное подключение последовательно к каждой проверяемой телекамере;
	после успешного подключения вывести видеопоток от проверяемой телекамеры на экран;
	выполнить визуальную сверку параметров изображения выведенного видеопотока со следующими показателями проектной документации: общее направление зоны обзора, расположение источника видеопотока на несущей конструкции, визуальный охват зоны охраны соответствующего маяка СКПТ, отсутствие «мёртвых зон» при визуальном охвате зоны охраны соответствующего маяка СКПТ;
	выполнить визуальное подтверждение качества видеопотока по следующим параметрам: отсутствие визуальных искажений физического характера (повреждение или загрязнение оптики, засветка), отсутствие визуальных искажений программно-аппаратного характера («артефакты» и сбои в обработке изображения на матрице телекамеры, читаемость и актуальность подписей), отсутствие в зоне обзора объектов, частично либо полностью загораживающих зону обзора
"
$cams_array = 1..$cams_nums_user
foreach ($cam_num_user in $cams_array){
    $cam_num = $cam_num_user + 128
    $urls = @("http://$ip_cams.$cam_num")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }

$check = Read-Host "Пункт 7.3.9,10 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}

#
function step070401 {
Clear-Host
Write-Host "Пункт 7.4.1,2,3
1. Проверка отображения состояния элементов СКПТ на АПК «АРМ Объект»
2. Проверка отображения телекамер СКПТ на АПК «АРМ Объект»
3. Управление режимами функционирования СКПТ средствами АПК «АРМ Объект»
"
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://$ip_station.193"
$check = Read-Host "Пункт 7.4.1,2,3 пройден для Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Stop-Process -Name firefox -ErrorAction Ignore
}

function step070404 {
Clear-Host
Write-Host "Пункт 7.4.4 Проверка автоматического запуска служб на сервере СПО
	Подать команду на перезагрузку сервера АПК «Объектовый сервер»;
	Дождаться завершения перезагрузки АПК «Объектовый сервер»;
	После завершения перезагрузки считать показания от АПК «Объектовый сервер».

"
mstsc /v:$ip_station.193 /prompt

$check = Read-Host "Пункт 7.4.4 пройден для Сервера СПО СПКТ? (Y\N)
[0] Возврат к выбору пункта ПМИ "
if ($check -eq "0")
{
user_choise
}
}

#Пропустим пункт 7.4.4 его конце
function step070405 {
Clear-Host
Write-Host "Пункт 7.4.5 Проверка автоматического запуска служб на сервере видеонаблюдения
	Подать команду на перезагрузку сервера видеонаблюдения;
	Дождаться завершения перезагрузки сервера видеонаблюдения;
	После завершения перезагрузки считать показания от сервера видеонаблюдения

"
putty "$ip_station.194"

$check = Read-Host "Пункт 7.4.5 пройден для Видео Сервера СПКТ? (Y\N) 
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}

#
function step070409 {
Clear-Host
Write-Host "Пункт 7.4.9 Проверка конфигураций коммутационного оборудования ОУ СКПТ
	выполняется проверка настройки портов коммутатора («vlan», «description», состояние, тип интерфейса, тип порта)
"
putty "$ip_station.129"
& "C:\Program Files\Google\Chrome\Application\chrome.exe" "$ip_station.250"
Start-Sleep -Seconds 2
$lantans_array = 1..$post_nums_user
foreach ($post_nums_user in $lantans_array){
    $lantan_num = $post_nums_user + 136
    $urls = @("http://$ip_station.$lantan_num")
        foreach($url in $urls){
           & "C:\Program Files\Google\Chrome\Application\chrome.exe" "$url"
        Start-Sleep -Seconds 2}
        }
$check = Read-Host "Пункт 7.4.9 пройден для Сервера СПКТ? (Y\N)
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
Write-Host "Уважаемая комиссия, улаоенное ПМИ завершено, просим вынести свое решение.
Спасибо за внимание!
"
} 


function step070410 {
Clear-Host
Write-Host "Пункт 7.4.10 - Проверка настроек серверного оборудования ОУ СКПТ
	проверить установленные компоненты «Microsoft Windows server» и их обновления;
	средствами Windows проверить настройку брандмауэра, настройка брандмауэра должна соответствовать политике домена «ISVN.local» (сетевые параметры указаны в «Эксплуатационной таблице»);
	средствами Windows проверить настройку электропитания, переход в спящий режим должен быть отключен;
	средствами Windows проверить настройку сетевых параметров (IP, GW, NTP), настройки должны совпадать с «Эксплуатационной таблицей»;
	средствами Windows проверить правильность настройки даты и времени;
	средствами Windows проверить настройку языков ввода (язык интерфейса - русский, язык ввода – английский);

"
mstsc /v:$ip_station.193 /prompt
putty

$check = Read-Host "Пункт 7.4.10 продемонтрирован для Сервера СПО СПКТ.
[0] Возврат к выбору пункта ПМИ"
if ($check -eq "0")
{
user_choise
}
}

function subMenu2 {
Clear-Host
Write-Host "
[1] 7.1.1 ч.2 -  Выполняется предъявление Подрядчиком резервной копии настроек и операционных систем ОУ СКПТ

[2] 7.1.2     -  Проверка сетевой доступности оборудования в соответствии с эксплуатационной таблицей

[3] 7.1.3     -  Проверка авторизации на оборудовании (вход по логину и паролю) в соответствии с эксплуатационной таблицей

[4] 7.1.5     -  Проверка лицензионных ключей программного обеспечения ОУ СКПТ

[5] 7.1.6     -  Проверка сервисов мониторинга состояния системы ПАК ОУ СКПТ

[6] 7.1.8     -  Проверка авторизации на серверном оборудовании ПАК ОУ СКПТ с помощью учетной записи Active Directory

[7] 7.1.9     -  Проверка корректности настройки DNS ПАК ОУ СКПТ

[8] 7.1.10    -  Проверка работоспособности Видеорегистрации

[9] 7.1.11,12 -  Проверка комплектации сервера видеонаблюдения и АПК «Объектовый сервер» ОУ СКПТ (7.1.11)
                 Настроек RAID (7.1.12)

[10] 7.3.9,10  -  Проверка функционирования телекамер (7.3.9) 
                 Проверка Зон (7.3.10)

[11] 7.4.1,2,3 - Проверка отображения состояния элементов СКПТ на АПК «АРМ Объект» (7.4.1), 
                 Отображения телекамер СКПТ на АПК «АРМ Объект» (7.4.2),
                 Управление режимами функционирования СКПТ средствами АПК «АРМ Объект» (7.4.3)
                
[12] 7.4.4     -  Проверка автоматического запуска служб на АПК «Объектовый сервер»

[13] 7.4.5     -  Проверка автоматического запуска служб на сервере видеонаблюдения

[14] 7.4.9     -  Проверка конфигураций коммутационного оборудования ОУ СКПТ

[15] 7.4.10    -  Проверка настроек серверного оборудования ОУ СКПТ


[0] Выход в главное меню
"
$choice2= Read-Host "Выберете пунт ПМИ"
    if($choice2 -eq "1"){
    step070101
    }
    if($choice2 -eq "2"){
    step070102
    }
    if($choice2 -eq "3"){
    step070103
    }
    if($choice2 -eq "4"){
    step070105
    }
    if($choice2 -eq "5"){
    step070106
    }
    if($choice2 -eq "6"){
    step070108
    }
    if($choice2 -eq "7"){
    step070109
    }
	if($choice2 -eq "8"){
	step070110
	}
    if($choice2 -eq "9"){
    step070111
    }
    if($choice2 -eq "10"){
    step070309
    }
    if($choice2 -eq "11"){
    step070401
    }
    if($choice2 -eq "12"){
    step070404
    }
    if($choice2 -eq "13"){
    step070405
    }
    if($choice2 -eq "14"){
    step070409
    }
    if($choice2 -eq "15"){
    step070410
    }
    if($choice2 -eq "0"){
    mainMenu
    }
    }
	
function remote {
	Clear-Host
	Write-Host "
[1] 7.1.2     -  Проверка сетевой доступности оборудования в соответствии с эксплуатационной таблицей

[2] 7.1.8     -  Проверка авторизации на серверном оборудовании ПАК ОУ СКПТ с помощью учетной записи Active Directory

[3] 7.1.9     -  Проверка корректности настройки DNS ПАК ОУ СКПТ

[4] 7.3.9,10  -  Проверка функционирования телекамер (7.3.9) 
                 Проверка Зон (7.3.10)

[5] 7.4.9     -  Проверка конфигураций коммутационного оборудования ОУ СКПТ

[6] 7.4.10    -  Проверка настроек серверного оборудования ОУ СКПТ


[0] Выход в главное меню
"
$choice4= Read-Host "Выберете пунт ПМИ"
    if($choice4 -eq "1"){
    step070102
    }
    if($choice4 -eq "2"){
    step070108
    }
    if($choice4 -eq "3"){
    step070109
    }
    if($choice4 -eq "4"){
    step070309
    }
    if($choice4 -eq "5"){
    step070409
    }
    if($choice4 -eq "6"){
    step070410
    }
    if($choice4 -eq "0"){
    mainMenu
    }
    }

function day {
	Clear-Host
	Write-Host "
[1] 7.1.5     -  Проверка лицензионных ключей программного обеспечения ОУ СКПТ

[2] 7.1.6     -  Проверка сервисов мониторинга состояния системы ПАК ОУ СКПТ

[3] 7.1.7     -  Проверка статуса сервиса менеджмента серверов ПАК ОУ СКПТ

[4] 7.1.10    -  Проверка работоспособности Видеорегистрации

[5] 7.1.11,12 -  Проверка комплектации сервера видеонаблюдения и АПК «Объектовый сервер» ОУ СКПТ (7.1.11)
                 Настроек RAID (7.1.12)
				 
[6] 7.3.7     -  Контроль срабатывания УКПТ на подвижной состав

[7] 7.4.1,2,3 - Проверка отображения состояния элементов СКПТ на АПК «АРМ Объект» (7.4.1), 
                Отображения телекамер СКПТ на АПК «АРМ Объект» (7.4.2),
                Управление режимами функционирования СКПТ средствами АПК «АРМ Объект» (7.4.3)
                
[8] 7.4.4     -  Проверка автоматического запуска служб на АПК «Объектовый сервер»

[9] 7.4.5     -  Проверка автоматического запуска служб на сервере видеонаблюдения


[0] Выход в главное меню
"
$choice5= Read-Host "Выберете пунт ПМИ"
    if($choice5 -eq "1"){
    step070105
    }
    if($choice5 -eq "2"){
    step070106
    }
	if($choice5 -eq "3"){
    step070107
    }
	if($choice5 -eq "4"){
	step070110
	}
    if($choice5 -eq "5"){
    step070111
    }
	if($choice5 -eq "6"){
    step070307
    }
    if($choice5 -eq "7"){
    step070309
    }
    if($choice5 -eq "8"){
    step070404
    }
    if($choice5 -eq "9"){
    step070405
    }
    if($choice5 -eq "0"){
    mainMenu
    }
    }

	
function remote_or_day {
	Clear-Host
	Write-Host "Выберете удаленные или дневные испытания"
	Write-Host "===Меню прохождения ПМИ==="
	Write-Host "[1].Удаленные испытания"
	Write-Host "[2].Дневные испытания"
	Write-Host "[0].Выход"
	$choice3 = Read-Host "Выберете пункт меню"
	if($choice3 -eq "1"){
    remote
    }
	if($choice3 -eq "2"){
    day
    }
	if($choice3 -eq "0"){
    mainMemu
    }
}
function user_choise {
		if ($choice3 -eq "1") {
		remote
		}
		if ($choice3 -eq "2") {
		day
		}
}

function mainMenu {
		Clear-Host
		
		Write-Host "===Меню прохождения ПМИ==="
		Write-Host "[1].Выбрать удаленные или дневные испытания"
		Write-Host "[2].Выбрать пункт ПМИ"
		Write-Host "[0].Выход"
        $choice1 = Read-Host "Выберете пункт меню"
		if($choice1 -eq 1){
        remote_or_day
        }
        if($choice1 -eq 2){
        subMenu2
        }
        if($choice1 -eq 0){
        Exit
        }
}

mainMenu