#!/bin/bash
    # WordPressInstall, a simple WordPress installation script
    # Copyright (C) 2021  Filip Strajnar
    
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <https://www.gnu.org/licenses/>.

function AmRootBool {
      if [[ `whoami` == "root" ]]; then
            echo "1" ;
            return ;
      fi
      echo "0";
}

function RegularUserInstall {
      if ! command -v apt &> /dev/null
      then
      echo 'You do not have APT package manager. This script will not work. Exiting.'
      exit
      fi
      echo -e "\e[1;44m Updating and upgrading packages. \e[0m"
      sudo apt -y update ; sudo apt -y upgrade ;\
      sudo apt-get install mysql-server -y ; \
      echo -e "\e[1;44m Installing MySQL server. \e[0m"
      sudo apt-get install mysql-server -y ; \
      echo -e "\e[1;44m Installing PHP for MySQL. \e[0m"
      sudo apt-get install php-mysql -y ; \
      echo -e "\e[1;44m Installing apache2 (HTTPD). \e[0m"
      sudo apt-get install apache2 -y ; \
      echo -e "\e[1;44m Installing PHP. \e[0m"
      sudo apt-get install php -y ; \
      echo -e "\e[1;44m Installing Mariadb server. \e[0m"
      sudo apt-get install mariadb-server  -y ; \
      sudo apt-get install openssl -y ; \
      echo -e "\e[1;44m Changing working directory to var www html. \e[0m"
      cd /var/www/html/ && \
      echo -e "\e[1;44m Emptying html directory. \e[0m"
      sudo rm * && \
      echo -e "\e[1;44m Downloading latest version of WordPress. \e[0m"
      sudo wget http://wordpress.org/latest.tar.gz && \
      echo -e "\e[1;44m Extracting WordPress. \e[0m"
      sudo tar xzf latest.tar.gz && \
      echo -e "\e[1;44m Removing compressed archive. \e[0m"
      sudo rm -rf latest.tar.gz && \
      echo -e "\e[1;44m Moving extracted wordpress files to root of html directory. \e[0m"
      sudo mv wordpress/* . && \
      echo -e "\e[1;44m Removing empty directory. \e[0m"
      sudo rm -rf wordpress && \
      echo -e "\e[1;44m Giving ownership of html directory to www-data. This way Apache will be able to host the WordPress website. \e[0m"
      sudo chown -R www-data: . &&\
      echo -e "\e[1;44m Changing working directory to apache2. You may chose to modify configuration files here. \e[0m"
      cd /etc/apache2/ &&\
      echo -e "\e[1;42m Please insert username for your WordPress user on MySQL database  \
      IMPORTANT: You need to remember this username as WordPress setup website WILL ask you for it! \e[0m"
      read sql_username ;\
      if [ -z "$sql_username" ]
      then
            echo "Username hasn't been selected. Default: username" ;\
            echo "When WordPress asks you for database username, you let it be \"username\". Literally.";\
            sql_username='username'
      else
            echo "Username chosen: $sql_username"
      fi
      echo -e "\e[1;42m Please insert PASSWORD for your WordPress user on MySQL database  \
      IMPORTANT: You need to remember this password as WordPress setup website WILL ask you for it! \e[0m"
      read sql_password ;\
      if [ -z "$sql_password" ]
      then
            openssl rand -base64 -out /home/$USER/WordPress_database.password 40 ;\
            echo "Password hasn't been selected. Generated strong random password: "; cat /home/$USER/WordPress_database.password ;\
            sql_password=`cat /home/$USER/WordPress_database.password`;
      else
            echo "Password chosen: $sql_password"
            echo $sql_password > /home/$USER/WordPress_database.password
      fi

      sudo mysql -u root -e "CREATE USER '$sql_username'@'localhost' IDENTIFIED BY '$sql_password';" ;\
      sudo mysql -u root -e "create database IF NOT EXISTS wordpress;" ;\
      sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$sql_username'@'localhost';"

}

function RootUserInstall {
      if ! command -v apt &> /dev/null
      then
            echo 'You do not have APT package manager. This script will not work. Exiting.'
            exit
      fi
      echo -e "\e[1;44m Updating and upgrading packages. \e[0m"
      apt -y update ; apt -y upgrade ;\
      apt-get install wget -y ; \
      echo -e "\e[1;44m Installing MySQL server. \e[0m"
      apt-get install mysql-server -y ; \
      echo -e "\e[1;44m Installing PHP for MySQL. \e[0m"
      apt-get install php-mysql -y ; \
      echo -e "\e[1;44m Installing apache2 (HTTPD). \e[0m"
      apt-get install apache2 -y ; \
      echo -e "\e[1;44m Installing PHP. \e[0m"
      apt-get install php -y ; \
      echo -e "\e[1;44m Installing Mariadb server. \e[0m"
      apt-get install mariadb-server  -y ; \
      apt-get install openssl -y ; \
      echo -e "\e[1;44m Changing working directory to var www html. \e[0m"
      cd /var/www/html/ && \
      echo -e "\e[1;44m Emptying html directory. \e[0m"
      rm * && \
      echo -e "\e[1;44m Downloading latest version of WordPress. \e[0m"
      wget http://wordpress.org/latest.tar.gz && \
      echo -e "\e[1;44m Extracting WordPress. \e[0m"
      tar xzf latest.tar.gz && \
      echo -e "\e[1;44m Removing compressed archive. \e[0m"
      rm -rf latest.tar.gz && \
      echo -e "\e[1;44m Moving extracted wordpress files to root of html directory. \e[0m"
      mv wordpress/* . && \
      echo -e "\e[1;44m Removing empty directory. \e[0m"
      rm -rf wordpress && \
      echo -e "\e[1;44m Giving ownership of html directory to www-data. This way Apache will be able to host the WordPress website. \e[0m"
      chown -R www-data: . &&\
      echo -e "\e[1;44m Changing working directory to apache2. You may chose to modify configuration files here. \e[0m"
      cd /etc/apache2/ &&\
      echo -e "\e[1;42m Please insert username for your WordPress user on MySQL database  \
      IMPORTANT: You need to remember this username as WordPress setup website WILL ask you for it! \e[0m"
      read sql_username ;\
      if [ -z "$sql_username" ]
      then
            echo "Username hasn't been selected. Default: username" ;\
            echo "When WordPress asks you for database username, you let it be \"username\". Literally.";\
            sql_username='username'
      else
            echo "Username chosen: $sql_username"
      fi
      echo -e "\e[1;42m Please insert PASSWORD for your WordPress user on MySQL database  \
      IMPORTANT: You need to remember this password as WordPress setup website WILL ask you for it! \e[0m"
      read sql_password ;\
      if [ -z "$sql_password" ]
      then
            mkdir /etc/WordPressInstall
            openssl rand -base64 -out /etc/WordPressInstall/WordPress_database.password 40 ;\
            echo "Password hasn't been selected. Generated strong random password: "; cat /etc/WordPressInstall/WordPress_database.password ;\
            sql_password=`cat /etc/WordPressInstall/WordPress_database.password`;
      else
            echo "Password chosen: $sql_password"
            echo $sql_password > /etc/WordPressInstall/WordPress_database.password
      fi

      mysql -u root -e "CREATE USER '$sql_username'@'localhost' IDENTIFIED BY '$sql_password';" ;\
      mysql -u root -e "create database IF NOT EXISTS wordpress;" ;\
      mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$sql_username'@'localhost';"
}

if (( `AmRootBool` )); then
      RootUserInstall
else
      RegularUserInstall
fi
