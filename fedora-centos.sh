#! /bin/bash
### Systèmes
## Mise à jour
# Optimisations vitesse mise à jour
isfm=$(grep -c fastestmirror /etc/dnf/dnf.conf)
	if [[ "$isfm" -eq "0" ]]
		then
			echo "fastestmirror=1" >> /etc/dnf/dnf.conf
	fi
# Mise à jour
echo -e '\n\e[0;36m'"Mise à jour en cours, merci de patienter"
dnf -y --nogpgcheck --refresh upgrade 
echo 
## Sécurité
# SELinux
echo -e '\n\e[0;36m'"Changer le mode de SELinux ? Actuellement :"'\e[0;35m'
sestatus | grep "SELinux status"
sestatus | grep "Current mode"
echo -e " \e[1;32menforcing\e[0;m : accès restreints \n \e[1;32mpermissive\e[0;m : les règles SELinux sont interrogées, les erreurs sont logguées mais rien n'est bloqué \n \e[1;32mdisabled\e[0;m  : accès non restreint, rien n’est enregistré"
	read selinux
		if [ "$selinux" = 'enforcing' -o "$selinux" = 'permissive' -o "$selinux" = 'disabled' ]
			then
				sed -e "s/SELINUX=.*/SELINUX=$selinux/" -i /etc/sysconfig/selinux
		fi
		echo -e '\e[0;31m'SELinux sera en mode $selinux au prochain redémarrage!'\e[0;m'
# SSH
echo -e '\n\e[0;36m'"Activer le serveur SSH? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
	read ssh
		if [ "$ssh" = 'o' ]
			then
			systemctl enable --now sshd.service
			echo -e '\e[0;31m'Le serveur SSH est maintenant activé!'\e[0;m'
			else
				echo -e '\e[0;31m'Le serveur SSH ne sera pas activé...'\e[0;m'
		fi
## Ajout pilotes
# Nvidia
echo -e '\n\e[0;36m'"Installer les pilotes Nvidia? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addnvidia
if [ "$addnvidia" = 'o' ]
	then 
		echo -e '\n\e[0;36m'"installation en cours.. Merci de patienter!"
		dnf install --nogpgcheck -y xorg-x11-drv-nvidia akmod-nvidia xorg-x11-drv-nvidia-cuda 
		echo -e '\e[0;31m'"Pilotes Nvidia installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Les pilotes Nvidia ne seront pas installés."'\e[0;m'
fi
# Broadcom
echo -e '\n\e[0;36m'"Installer les pilotes Broadcom? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addbroadcom
if [ "$addbroadcom" = 'o' ]
	then 
		dnf install --nogpgcheck -y akmod-wl 
		echo -e '\e[0;31m'"Pilotes Broadcom installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Les pilotes Broadcom ne seront pas installés."'\e[0;m'
fi

## Suppression des packets inutiles
# Packagekit
echo -e '\n\e[0;36m'"Supprimer GnomePackagekit? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m) \nGNOME-Packagekit (Paquets) est le gestionnaire de paquets graphique du bureau GNOME, il permet de chercher des paquets spécifiques et fournit des résultats très exhaustifs et précis."
read removepackagekit
	if [ "$removepackagekit" = 'o' ]
	then
		dnf -y autoremove gnome-software gnome-packagekit 
		echo -e '\e[0;31m'"Packagekit supprimé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucune action faite sur Packagekit.."'\e[0;m'
fi
# GNOMESoftware
echo -e '\n\e[0;36m'"Supprimer la logithèque de GNOME? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m) \nLa logithèque GNOME présente un catalogue de plusieurs milliers d'applications permettant d'enrichir en un simple clic votre installation avec de nouveaux logiciels."
read removegnomesoft
	if [ "$removegnomesoft" = 'o' ]
	then
		dnf -y autoremove gnome-software 
		echo -e '\e[0;31m'"Logithèque supprimé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucune action faite sur la logithèque.."'\e[0;m'
fi
# ExtraGNOME
echo -e '\n\e[0;36m'"Supprimer les logiciels préinstallé avec GNOME? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read removeextragnome
	if [ "$removeextragnome" = 'o' ]
	then
		dnf -y autoremove baobab cheese epiphany gnome-{calendar,characters,clocks,contacts,dictionary,disk-utility,font-viewer,logs,maps,photos,user-docs,,weather} gucharmap sushi 
		echo -e '\e[0;31m'"Logiciels GNOME préinstallé supprimé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucune action faite sur les logiciels prèinstallés avec GNOME.."'\e[0;m'
fi
# Suppression du rapport de bug automatique
echo -e '\n\e[0;36m'"Supprimer le rapport du bug automatique? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read removeabrtd 
	if [ "$removeabrtd" = 'o' ]
	then
		dnf autoremove -y abrtd* 
		echo -e '\e[0;31m'"Rapport de bug supprimé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Rapport du bug conservé."'\e[0;m'
	fi
# Suppression de Libvirt
echo -e '\n\e[0;36m'"Supprimer Libvirt? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)\nlibvirt est un ensemble d'outils de gestion de la virtualisation (ex : GNOME Machine)."
read removelibvirt
	if [ "$removelibvirt" = 'o' ]
	then
		dnf autoremove -y abrtd* 
		echo -e '\e[0;31m'"Libvirt supprimé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Libvirt conservé."'\e[0;m'
	fi

### Ajout de dépots/logiciels
## Ajout Dépot
# RPM Fusion Free
echo -e '\n\e[0;36m'"Activer le dépot RPM Fusion FREE? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read rpmfusion
	if [ "$rpmfusion" = 'o' ]
		then
			dnf install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
			if [ "$removegnomesoft" ='o' ]
				then
					echo -e '\e[0;36m'"Ajouter le dépot RPM Fusion FREE à la logithèque Gnome? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
					read rpmfusiondep
					if [ "$rpmfusiondep" = 'o' ]
						then
							dnf install rpmfusion-free-appstream-data -y 
							echo -e '\e[0;31m'Le dépot RPM Fusion FREE est maintenant installé et ajouté à la lodothèque Gnome!'\e[0;m'
						else
							echo -e '\e[0;31m'Le dépot RPM Fusion FREE est maintenant installé!'\e[0;m'
					fi
				fi
		else
			echo -e '\e[0;31m'Le dépot RPM Fusion FREE ne sera pas installé..'\e[0;m'
	fi
# RPM Fusion nonFree
echo -e '\n\e[0;36m'"Activer le dépot RPM Fusion NON-FREE? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read rpmfusionnon
	if [ "$rpmfusionnon" = 'o' ]
		then
			dnf install --nogpgcheck https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
				if [ "$removegnomesoft" ='o' ]
					then
						echo -e '\e[0;36m'"Ajouter le dépot RPM Fusion NON-FREE à la logithèque Gnome? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
						read rpmfusionnondep
						if [ "$rpmfusionnondep" = 'o' ]
							then
								dnf install rpmfusion-nonfree-appstream-data -y 
								echo -e '\e[0;31m'Le dépot RPM Fusion NON-FREE est maintenant installé et ajouté à la lodothèque Gnome!'\e[0;m'
							else
								echo -e '\e[0;31m'Le dépot RPM Fusion NON-FREE est maintenant installé!'\e[0;m'
						fi
				fi
		else
			echo -e '\e[0;31m'Le dépot RPM Fusion NON-FREE ne sera pas installé..'\e[0;m'
	fi
# Third Party Software
echo -e '\n\e[0;36m'"Activer les third party software? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read tps
	if [ "$tps" = 'o' ]
		then
			dnf install fedora-workstation-repositories 
			echo -e '\e[0;31m'"Third party software activé!"
		else
		echo -e '\e[0;31m'"Third party software ne sera pas activé.."'\e[0;m'
	fi
# Repo Chrome
echo -e '\n\e[0;36m'"Installer le dépot de Google Chrome? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read chrome
	if [ "$chrome" = 'o' ]
	then
		dnf config-manager --set-enabled google-chrome 
		echo -e '\e[0;31m'"Le dépot de Google Chrome est activé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Le dépot de Google Chrome ne sera pas activé.."'\e[0;m'
	fi
#flathub
echo -e '\n\e[0;36m'"Installer le dépot Flathub? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read flathub
	if [ "$flathub" = 'o' ]
	then
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 
		echo -e '\e[0;31m'"Le dépot Flathub est installé.."'\e[0;m'
		else
			echo -e '\e[0;31m'"Le dépot Flathub ne sera pas installé.."'\e[0;m'
	fi

## Ajout logiciels
# Codecs
echo -e '\n\e[0;36m'"Installer des codecs supplémentaires? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read codecs
	if [ "$codecs" = 'o' ]
		then
			dnf install --nogpgcheck -y gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-bad-nonfree gstreamer-plugins-ugly gstreamer1-plugins-{base,good,bad-free,good-extras,bad-free-extras} gstreamer1-plugin-mpg123 gstreamer1-libav gstreamer1-plugins-{bad-freeworld,ugly} 
			echo -e '\e[0;31m'"Codecs supplémentaires installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucun codecs supplémentaires ne sera installés.."'\e[0;m'
	fi
# Logiciels tiers
addsoftwares="bluefish filezilla keepassxc gimp wget optimizer retroarch thunderbird libreoffice-langpack-fr lollypop qownnotes terminator tcpdump htop vlc gnome-tweaks"
echo -e '\n\e[0;36m'"Installer les logiciels additionnels? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addsoftwaresrep
	if [ "$addsoftwaresrep" = 'o' ]
	then
		dnf install --nogpgcheck -y $addsoftwares
		echo -e '\e[0;31m'"Logiciels installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucun logiciels ne sera installés.."'\e[0;m'
	fi
# Wireshark
echo -e '\n\e[0;36m'"Installer Wireshark? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read wireshark
	if [ "$wireshark" = 'o' ]
	then
		dnf install --nogpgcheck -y wireshark 
		usermod -a -G wireshark $USER
		echo -e '\e[0;31m'"Wireshark installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Wireshark ne sera installés.."'\e[0;m'
	fi
# Oh-My-ZSH
echo -e '\n\e[0;36m'"Installer Oh-My-ZSH? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read ohmyzsh
	if [ "$wireshark" = 'o' ]
	then
		sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
		echo -e '\e[0;31m'"Oh-My-ZSH installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Oh-My-ZSH ne sera installés.."'\e[0;m'
	fi
# Extensions Gnome
echo -e '\n\e[0;36m'"Installer les extentions Gnome dash-to-dock, user-theme et gsconnect? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read gnomeextensions
	if [ "$gnomeextensions" = 'o' ]
	then
		dnf install --nogpgcheck -y gnome-shell-extension-{dash-to-dock,user-theme,gsconnect} 
		echo -e '\e[0;31m'"Extensions installés!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Aucune extensions ne sera installés.."'\e[0;m'
	fi
## Logiciels hors dépots
#VirtualBox
echo -e '\n\e[0;36m'"Installer Vitualbox? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addvirtualbox
	if [ "$addvirtualbox" = 'o' ]
	then
		dnf install --nogpgcheck -y VirtualBox 
		akmods
		systemctl restart systemd-modules-load.service
		echo -e '\e[0;31m'"VirtualBox installé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"VirtualBox ne sera pas installé."'\e[0;m'
	fi
# Steam
echo -e '\n\e[0;36m'"Installer Steam? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addsteam
	if [ "$addsteam" = 'o' ]
	then
		dnf install --nogpgcheck -y steam 
		echo -e '\e[0;31m'"Steam installé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Steam ne sera pas installé."'\e[0;m'
	fi
# Teamviewer
echo -e '\n\e[0;36m'"Installer Teamviewer? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addtv
if [ "$addtv" = 'o' ]
	then 
		wget -q https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
		dnf -y install teamviewer.x86_64.rpm 
		rm teamviewer.x86_64.rpm
		echo -e '\e[0;31m'"Teamviewer installé!"'\e[0;m'
		else
			echo -e '\e[0;31m'"Teamviewer ne sera pas installé."'\e[0;m'
fi
# Balena Etcher
echo -e '\n\e[0;36m'"Installer Balena Etcher? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read addbe
if [ "$addbe" = 'o' ]
	then 
		wget -q https://balena.io/etcher/static/etcher-rpm.repo -O /etc/yum.repos.d/etcher-rpm.repo
		dnf install -y balena-etcher-electron 
		echo -e '\e[0;31m'"Balena Etcher installé!"'\e[0;m'
		else
				echo -e '\e[0;31m'"Balena Etcher ne sera pas installé."'\e[0;m'
fi
# Flatpak
addflatpak="net.xmind.ZEN com.spotify.Client com.anydesk.Anydesk com.sublimetext.three"
if [ "$flathub" = 'o' ]
	then
		echo -e '\n\e[0;36m'"Installer les Flatpaks? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
		read $addflatpaks
		if [ "$addflatpaks" = 'o' ]
			then
				flatpak install flathub $addflatpak -y 
				echo -e '\e[0;31m'"Flatpaks installés!"'\e[0;m'
			else
				echo -e '\e[0;31m'"Aucun Flatpaks ne sera installés.."'\e[0;m'
	fi
fi
## Autres
# Scanner
echo -e '\n\e[0;36m'"Disposez-vous d'un scanner? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read scann
if [ "$scann" = 'o' ]
	then 
		echo -e '\e[0;31m'"Simple-Scan sera concervé!"'\e[0;m'
		else
		dnf -y autoremove simple-scan 
		echo -e '\e[0;31m'"Simple-Scan est supprimé!"'\e[0;m'
fi
# Reboot
echo -e '\n\e[0;36m'"Opérations terminée, merci de redémarrer ! \nSouhaitez-vous le faire imédiatement? \e[0;m(\e[1;32mo\e[0;m/\e[1;32mN\e[0;m)"
read reboot
	if [ "$reboot" = 'o' ]
	then
		reboot
		else
		echo -e '\e[0;31m'"Redémarrer pour que l'ensemble des modifications soient prise en compte."'\e[0;m'
fi
