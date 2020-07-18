#! /bin/bash
## Check root
if [[ $EUID -ne 0 ]]
then
sudo chmod +x $(dirname $0)/$0
sudo $(dirname $0)/$0
exit;
fi
## Distribution
	echo -e '\e[0;36m'"Distribution ? \n \e[1;32m1\e[0;m="Fedora" \n \e[1;32m2\e[0;m="Debian""
	read distribution
## renvois vers script dédié
if [ $distribution = "1" ]
	then
		. "$PWD/fedora-centos.sh"
	elif [ $distribution = "2" ]
		then
			. "$PWD/debian-ubuntu.sh"
	else
		echo -e '\e[0;31m'"\nMerci de faire un choix"
fi