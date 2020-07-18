#! /bin/bash
# Optimisations vitesse mise à jour
apt update && apt install netselect-apt -y && netselect-apt -t 15 -a amd64 -n stable
## Mise à jour
apt update && apt dist-upgrade -y
# SSH
echo -e '\e[0;36m'"Activer le serveur SSH? \n \e[1;32mo\e[0;m="Oui" \n \e[1;32mn\e[0;m="Non""
	read ssh
	if [ $ssh = "o" ]
		then
		systemctl enable --now sshd.service
		echo -e '\e[0;31m'Le serveur SSH est maintenant activé!'\e[0;m'
		else
		echo -e '\e[0;31m'Le serveur SSH ne sera pas activé...'\e[0;m'
fi