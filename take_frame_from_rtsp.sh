read -p "Введите имя станции: " name_station
read -p "Введите первые 3 октета камер на станции (Пример 10.0.0): " ip_station;
read -p "Введите кол-во камер на станции: " nums_camera;
home_dir=/home/zabbix/video_pmi
mkdir $home_dir/$name_station
echo "Снимаем скриншоты с камер на станции $name_station ..."
for ip_array_camera in $(seq 1 $nums_camera);
        do
                ip_array_camera=$(($ip_array_camera+128))
                ip_camera="$ip_station.$ip_array_camera"
                ffmpeg -y -i "rtsp://admin:Qwerty1!@$ip_camera:554/Streaming/Channels/101" -frames:v 1 -f image2 $home_dir/$name_station/$ip_camera.jpg &> /dev/null
        done
echo "Архивируем и отправляем архив на 10.250.80.30/screenshots"
zip -r $name_station.zip ./$name_station/ $> /dev/null
rm -rf ./$name_station
#cp $home_dir/$name_station.zip /mnt/screenshots/
cp /home/zabbix/video_pmi/$name_station.zip /mnt/sreenshots/
echo "Выполнено!"

