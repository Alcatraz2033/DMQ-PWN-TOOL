#!/bin/bash

RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')" END="$(printf '\033[0m\e[0m')"

if [ $(id -u) -ne "0" ];then
    echo -e "\n[${RED}!${END}]${RED} Ejecute este script como root.${END}"
    exit 1
fi 

ctrl_c(){
    echo -e "\n[${RED}!${END}] ${RED}SALIENDO...${END}\n"
    exit 1
}
trap ctrl_c INT

banner() {
	cat <<- EOF
	
${RED}▓█████▄  ███▄ ▄███▓  █████      ██▓███   █     █░ ███▄    █ 
▒██▀ ██▌▓██▒▀█▀ ██▒▒██▓  ██▒   ▓██░  ██▒▓█░ █ ░█░ ██ ▀█   █ 
░██   █▌▓██    ▓██░▒██▒  ██░   ▓██░ ██▓▒▒█░ █ ░█ ▓██  ▀█ ██▒
░▓█▄   ▌▒██    ▒██ ░██  █▀ ░   ▒██▄█▓▒ ▒░█░ █ ░█ ▓██▒  ▐▌██▒
░▒████▓ ▒██▒   ░██▒░▒███▒█▄    ▒██▒ ░  ░░░██▒██▓ ▒██░   ▓██░
 ▒▒▓  ▒ ░ ▒░   ░  ░░░ ▒▒░ ▒    ▒▓▒░ ░  ░░ ▓░▒ ▒  ░ ▒░   ▒ ▒ 
 ░ ▒  ▒ ░  ░      ░ ░ ▒░  ░    ░▒ ░       ▒ ░ ░  ░ ░░   ░ ▒░
 ░ ░  ░ ░      ░      ░   ░    ░░         ░   ░     ░   ░ ░ 
   ░           ░       ░                    ░             ░ 
 ░                                                          
▄▄▄█████▓ ▒█████   ▒█████   ██▓                             
▓  ██▒ ▓▒▒██▒  ██▒▒██▒  ██▒▓██▒                             
▒ ▓██░ ▒░▒██░  ██▒▒██░  ██▒▒██░                             
░ ▓██▓ ░ ▒██   ██░▒██   ██░▒██░                             
  ▒██▒ ░ ░ ████▓▒░░ ████▓▒░░██████▒                         
  ▒ ░░   ░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░▓  ░                         
    ░      ░ ▒ ▒░   ░ ▒ ▒░ ░ ░ ▒  ░                         
  ░      ░ ░ ░ ▒  ░ ░ ░ ▒    ░ ░                            
             ░ ░      ░ ░      ░  ░                         
         ${ORANGE}BY: Alcatraz2033 - https://github.com/Alcatraz2033${END}                                                              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	EOF
}

helpPanel(){
	echo -e "\n[${ORANGE}+${END}] ${ORANGE}PARAMETROS PARA EL USO DE LA HERRAMIENTA:${END}\n"
	echo -e "\t[${RED}-h${END}] ${BLUE}Muestra este panel de ayuda.${END}"
	echo -e "\t[${RED}-t${END}] ${BLUE}Espesifica el tarjet objetivo.${END}"
}

port_scann(){
	echo -e "[${ORANGE}PI-002 PI-003${END}] ${BLUE}REALIZANDO EL ESCANEO DE PUERTOS ABIERTOS A LA DIRECCION IP:${END} $1"
	sudo nmap -p- -sS --min-rate 5000 -n -Pn $1 -oN ports &>/dev/null
	cat ports | grep "tcp" | awk '{print $1, $2, $3}' | grep -vi not
}

os_discovery(){
    echo -e "\n[${ORANGE}PI-004 PI-022${END}] ${BLUE}REALIZANDO DETECCION DE SISTEMA OPERATIVO${END}"
    timeout 1 ping -c 1 $1 | grep -oP "ttl=.*" | awk '{print $1}' | tr -d 'ttl=' &>/dev/null

    if [[ $? -eq 0 ]]; then
        ttl_value=$(timeout 1 ping -c 1 $1 | grep -oP "ttl=.*" | awk '{print $1}' | tr -d 'ttl=')
        if [[ -n "$ttl_value" ]]; then  # Verifica si ttl_value no está vacío
            if [[ $ttl_value -le 64 ]]; then
                echo -e "[${ORANGE}+${END}] TTL DE $ttl_value SISTEMA OPERATIVO ${ORANGE}LINUX${END}"
            else
                echo -e "[${ORANGE}+${END}] TTL DE $ttl_value SISTEMA OPERATIVO ${ORANGE}WINDOWS${END}"
            fi
        else
            echo -e "[${RED}!${END}] ${RED}No se pudo determinar el TTL. Verifica la conectividad.${END}"
        fi
    else
        echo -e "[${RED}!${END}] ${RED}No se pudo realizar el ping. Verifica la conectividad.${END}"
    fi
    nmap -O --osscan-guess $1 | grep -i "\bOS\b" | grep -v nmap
}

show_wifi(){
	echo -e "\n[${ORANGE}PI-005${END}] ${BLUE}DETECCION Y EXPLORACION DE ENCRIPTACION EN REDES WIFI${END}"
	echo -e "[${ORANGE}+${END}] EL DISPOSITIVO SE ENCUENTRA CONECTADO EN LA RED ${ORANGE}$(nmcli connection show --active | awk '{print $1}' | head -n2 | grep -v NAME)${END} A TRAVEZ DE ${ORANGE}$(nmcli connection show --active | awk '{print $3}' | head -n2 | grep -v TYPE)${END}" 
	nmcli dev wifi list | head -n 15
}

web_identification(){
    echo -e "\n[${ORANGE}PI-006${END}] ${BLUE}IDENTIFICACION Y EXPLORACION DE APLICACIONES WEB${END}"
	cat ports | grep "http" &>/dev/null
	if [ $? -eq 0 ];then
		http_ports=$(cat ports | grep "http" | awk '{print $1, $3}' | grep -vi not | grep http | awk -F '/' '{print $1}')

		for i in $http_ports;do
			if [ $i -eq 443 ];then
				whatweb https://$1
			fi
			whatweb http://$1:$i
		done
	else
		echo -e "[${RED}!${END}] ${RED}NO SE IDENTIFICARON SERVICIOS HTTP HABIERTOS${END}"
	fi
}


process(){
	banner
	port_scann $1
	os_discovery $1
	show_wifi
	web_identification $1
}

parameter_counter=0; while getopts "t:h" arg; do
    case $arg in
        t) target=$OPTARG; let parameter_counter+=1;;
        h) helpPanel;; 
    esac  
done

if [ $parameter_counter -eq 0 ]; then
    helpPanel
    else
        if [ ! $target ]; then
            helpPanel
        else
            process $target
        fi  
fi
