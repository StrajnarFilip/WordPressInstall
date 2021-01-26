# WordPressInstall
WordPress installation script. Tested on Ubuntu 20.04 on day: 27.1.2020, tested on Debian 10 on day: 27.1.2020

After installation, you access your WordPress website via http://*your_public_ip*

If you changed default port (from 80), you will also have to append :*port* to the http address.

If you leave username prompt empty, it'll choose username. If you leave password prompt empty, it'll generate a strong password with OpenSSL. **Important:** if you will be inputing your own password, it has to be VERY secure in order for MySQL to accept it as valid.

By default, your WordPress database password will be saved in: **/home/$USER/WordPress_database.password**, you may use command **cat /home/$USER/WordPress_database.password** to view it.

git clone https://github.com/StrajnarFilip/WordPressInstall.git

# OR (the lazy method):

wget https://raw.githubusercontent.com/StrajnarFilip/WordPressInstall/main/WordPress.bash ; bash WordPress.bash

**On Debian you might need to install wget:**

sudo apt -y update ; sudo apt -y install wget ; wget https://raw.githubusercontent.com/StrajnarFilip/WordPressInstall/main/WordPress.bash ; bash WordPress.bash
