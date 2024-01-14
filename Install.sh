#!/bin/bash
#
. /lib/lsb/init-functions
sudo apt update && sudo apt -q install git gcc i2c-tools python3-dev python3-smbus -y
sudo apt -y install python3 python3-pip python3-pil libjpeg-dev zlib1g-dev libfreetype6-dev liblcms2-dev libopenjp2-7 
sudo -H pip3 install psutil --break-system-packages
if [ $? -eq 0 ]; then
    echo "Packages have successfully installed"
else
    echo "Operation failed"
    exit 1  # Exit the script if the operation failed
fi
sudo usermod -a -G gpio,i2c $USER
cd /usr/local/ 
   git clone https://github.com/rm-hull/luma.examples.git
   cd /usr/local/luma.examples/
   sudo -H pip3 install -e . --break-system-packages
   sudo sed -i '/dtparam=i2c_arm*/d' /boot/config.txt 
sudo sed -i '$a\dtparam=i2c_arm=on' /boot/config.txt 
sudo sed -i '$a\i2c-bcm2708' /etc/modules
sudo sed -i '$a\i2c-dev' /etc/modules
if [ $? -eq 0 ]; then
    echo "i2c has been set up successfully"
	echo "pip3 has been set up successfully"
else
    echo "Operation failed"
    exit 1  # Exit the script if the operation failed
fi
oled_svc="minitower_oled"
oled_svc_file="/lib/systemd/system/${oled_svc}.service"
sudo rm -f ${oled_svc_file}

echo "[Unit]" | sudo tee -a ${oled_svc_file} > /dev/null
echo "Description=Minitower Service" | sudo tee -a ${oled_svc_file} > /dev/null
echo "DefaultDependencies=no" | sudo tee -a ${oled_svc_file} > /dev/null
echo "StartLimitIntervalSec=60" | sudo tee -a ${oled_svc_file} > /dev/null
echo "StartLimitBurst=5" | sudo tee -a ${oled_svc_file} > /dev/null
echo "[Service]" | sudo tee -a ${oled_svc_file} > /dev/null
echo "RootDirectory=/" | sudo tee -a ${oled_svc_file} > /dev/null
echo "User=root" | sudo tee -a ${oled_svc_file} > /dev/null
echo "Type=forking" | sudo tee -a ${oled_svc_file} > /dev/null
echo "ExecStart=/bin/bash -c 'python3 /usr/local/luma.examples/examples/sys_info_extended.py &'" | sudo tee -a ${oled_svc_file} > /dev/null
echo "# ExecStart=/bin/bash -c '/python3 /usr/local/luma.examples/examples/clock.py &'" | sudo tee -a ${oled_svc_file} > /dev/null
echo "RemainAfterExit=yes" | sudo tee -a ${oled_svc_file} > /dev/null
echo "Restart=always" | sudo tee -a ${oled_svc_file} > /dev/null
echo "RestartSec=30" | sudo tee -a ${oled_svc_file} > /dev/null
echo "[Install]" | sudo tee -a ${oled_svc_file} > /dev/null
echo "WantedBy=multi-user.target" | sudo tee -a ${oled_svc_file} > /dev/null
sudo chown root:root ${oled_svc_file}
sudo chmod 644 ${oled_svc_file}
systemctl daemon-reload
systemctl enable ${oled_svc}.service
systemctl restart ${oled_svc}.service 

pwm_svc="pwm_fan"
pwm_svc_file="/lib/systemd/system/${pwm_svc}.service"
sudo rm -f ${pwm_svc_file}

echo "[Unit]" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "Description=Automatically adjust fan speed by temperature" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "DefaultDependencies=no" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "StartLimitIntervalSec=60" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "StartLimitBurst=5" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "[Service]" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "RootDirectory=/" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "User=root" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "Type=forking" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "ExecStart=/bin/bash -c 'python3 /usr/local/scripts/pwm_fan.py &'" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "RemainAfterExit=yes" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "Restart=always" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "RestartSec=30" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "[Install]" | sudo tee -a ${pwm_svc_file} > /dev/null
echo "WantedBy=multi-user.target" | sudo tee -a ${pwm_svc_file} > /dev/null
sudo chown root:root ${pwm_svc_file}
sudo chmod 644 ${pwm_svc_file}
systemctl daemon-reload
systemctl enable ${pwm_svc}.service
systemctl restart ${pwm_svc}.service 


sudo mkdir /usr/local/scripts/
pwm_fan="/usr/local/scripts/pwm_fan.py"
sudo rm -f ${pwm_fan}

echo "import RPi.GPIO as GPIO" | sudo tee -a ${pwm_fan} > /dev/null
echo "import time" | sudo tee -a ${pwm_fan} > /dev/null
echo "import subprocess as sp" | sudo tee -a ${pwm_fan} > /dev/null
echo ""
echo "FAN_PIN = 8" | sudo tee -a ${pwm_fan} > /dev/null
echo  ""
echo "GPIO.setmode(GPIO.BOARD)" | sudo tee -a ${pwm_fan} > /dev/null
echo "GPIO.setup(FAN_PIN, GPIO.OUT)" | sudo tee -a ${pwm_fan} > /dev/null
echo "pwm = GPIO.PWM(FAN_PIN, 50)" | sudo tee -a ${pwm_fan} > /dev/null
echo "pwm.start(0)" | sudo tee -a ${pwm_fan} > /dev/null
echo ""
echo "def update_fan_speed(temp):" | sudo tee -a ${pwm_fan} > /dev/null
echo "       if temp < 45.0:" | sudo tee -a ${pwm_fan} > /dev/null
echo "            return 0" | sudo tee -a ${pwm_fan} > /dev/null
echo "       elif 45.0 <= temp < 50.0:" | sudo tee -a ${pwm_fan} > /dev/null
echo "           return 30" | sudo tee -a ${pwm_fan} > /dev/null
echo "       elif 50.0 <= temp < 55.0:" | sudo tee -a ${pwm_fan} > /dev/null
echo "           return 60" | sudo tee -a ${pwm_fan} > /dev/null
echo "       elif 55.0 <= temp < 65.0:" | sudo tee -a ${pwm_fan} > /dev/null
echo "           return 80" | sudo tee -a ${pwm_fan} > /dev/null
echo "       else:" | sudo tee -a ${pwm_fan} > /dev/null
echo "           return 100" | sudo tee -a ${pwm_fan} > /dev/null
echo ""
echo "try:" | sudo tee -a ${pwm_fan} > /dev/null
echo "      while True:" | sudo tee -a ${pwm_fan} > /dev/null
echo "             temp = float(sp.getoutput(\"vcgencmd measure_temp|egrep -o '[0-9]*\\.[0-9]*'\"))" | sudo tee -a ${pwm_fan} > /dev/null
echo "             duty_cycle = update_fan_speed(temp)" | sudo tee -a ${pwm_fan} > /dev/null
echo "             pwm.ChangeDutyCycle(duty_cycle)" | sudo tee -a ${pwm_fan} > /dev/null
echo "             time.sleep(0.1)" | sudo tee -a ${pwm_fan} > /dev/null
echo ""
echo "except KeyboardInterrupt:" | sudo tee -a ${pwm_fan} > /dev/null
echo "      pwm.stop()" | sudo tee -a ${pwm_fan} > /dev/null
echo "      GPIO.cleanup()" | sudo tee -a ${pwm_fan} > /dev/null

sudo chown root:root ${pwm_fan}
sudo chmod 644 ${pwm_fan}
sudo sync
cd


if [ $? -eq 0 ]; then
    echo "Setup Finished This PC will now Reboot"
else
    echo "Operation failed"
    exit 1  # Exit the script if the operation failed
fi
echo "This PC will automatically Reboot in 10 Seconds" 
sleep 10
sudo rm -- "$0"
sudo reboot
