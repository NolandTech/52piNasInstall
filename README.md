<h1>52Pi Mini Nas Tower one script installation for RPi 4</h1> 
<h3>This script will install and enable all requirements for the 52Pi Nas mini tower display, and fan speed control, On the Raspberry Pi.</h3> 
<sup>Tested on DietPi OS, and Raspberry Pi OS (see known issues below).</sup><br /><br />
https://wiki.52pi.com/ ===> Mini Nas Tower<br /> 
https://dietpi.com/ ===> DietPi OS<br />
https://www.raspberrypi.com/software/   ===> Raspberry Pi<br /><br />


<b>Known issues with RaspberryPi OS: I2C needs to be manually enabled via raspi-config.(DietPi Users Skip this)<br /><br />
___
<ul>
  <h2>Enable I2C (DietPi Users can Skip this)</h2>
      <li>
To Enable I2C in RaspberryPi OS, in Terminal type:

    sudo raspi-config
		
<br />
</li>
<li>
Next go to Interface options. <---Here you will find the option to enable I2C. <br />
!You may do this at any time, before or after running the install script. <br /><br />
</li>
  
  ___
  
  <h2>Install Mini Nas Tower Display & Fan</h2>
To install Mini Nas Tower script type:
<li>
    cd
    sudo git clone https://github.com/NolandTech/pinas
    cd pinas
    sudo bash install.sh
	
</li>
<br /><br />
<li>
After running the install script your Raspberry Pi will reboot. Everything should now be enabled and working. 
<br /><br />

___
  
</li>

  <H2>Change Display Script</H2>
<li>
To change the display script, in Terminal type:

    sudo nano /lib/systemd/system/minitower_oled.service

</li><br />
<li>
find the line:
'python3 /usr/local/luma.examples/examples/sys_info_extended.py &'<br />
Replace the end of the line "sys_info_extended.py" with another script file from usr/local/luma.examples/examples/<br />
eg. 'python3 /usr/local/luma.examples/examples/clock.py &'  <br /><br />
<img src="https://wiki.52pi.com/images/9/93/Changesystemdservice3.png" width="600" height="200" alt="example">
</li>
<li>
<br /><br />
To find the list of scripts to use with the display, in Terminal type:

    cd /usr/local/luma.examples/examples/
    ls -a
		
All .py files listed can be used by editing "/lib/systemd/system/minitower_oled.service" file (shown above)
</li>
</ul>
<br /><br />
<a href="https://dietpi.com/downloads/images/DietPi_RPi-ARMv8-Bookworm.img.xz"><img src="https://github.com/NolandTech/Images-/blob/main/dietpi-logo_black_150x150.png" width="80" title="DietPi Download"></a> 
<a href="https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-12-11/2023-12-11-raspios-bookworm-arm64-lite.img.xz"><img src="https://github.com/NolandTech/Images-/blob/main/Raspberry_Pi-Logo.png" width="120" title="Raspberry Pi OS Lite Download"></a><br /><br />
