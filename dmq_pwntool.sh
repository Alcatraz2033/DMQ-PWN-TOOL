#!/bin/bash

RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')" END="$(printf '\033[0m\e[0m')"

if [ $(id -u) -ne "0" ];then
    echo -e "\n[${RED}FAIL${END}]${RED} Ejecute este script como root.${END}"
    pkill xterm
    exit 1
fi 

ctrl_c(){
    echo -e "\n[${RED}FAIL${END}] ${RED}SALIENDO...${END}\n"
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
	echo -e "\n[${MAGENTA}INFO${END}] PARAMETROS PARA EL USO DE LA HERRAMIENTA:\n"
	echo -e "\t[${RED}-h${END}] ${BLUE}Muestra este panel de ayuda.${END}"
	echo -e "\t[${RED}-t${END}] ${BLUE}Espesifica el tarjet objetivo.${END}"
	echo -e "\t[${RED}-i${END}] ${BLUE}Espesifica la interfaz de red para el sniffing.${END}"
	exit 1
}

port_scann(){
	echo -e "\n[${ORANGE}PI-002 | PI-003${END}] ${BLUE}REALIZANDO EL ESCANEO DE PUERTOS ABIERTOS A LA DIRECCION IP:${END} $1"
	sudo nmap -p- -sS --open --min-rate 5000 -n -Pn $1 -oN evidence/ports_$1 &>/dev/null
	cat evidence/ports_$1 | grep "tcp" | awk '{print $1, $2, $3}' | grep -vi not
}

os_discovery(){
    echo -e "\n[${ORANGE}PI-004 | PI-022${END}] ${BLUE}REALIZANDO DETECCION DE SISTEMA OPERATIVO${END}"
    timeout 1 ping -c 1 $1 | grep -oP "ttl=.*" | awk '{print $1}' | tr -d 'ttl=' &>/dev/null

    if [[ $? -eq 0 ]]; then
        ttl_value=$(timeout 1 ping -c 1 $1 | grep -oP "ttl=.*" | awk '{print $1}' | tr -d 'ttl=')
        if [[ -n "$ttl_value" ]]; then  # Verifica si ttl_value no está vacío
            if [[ $ttl_value -le 64 ]]; then
                echo -e "[${MAGENTA}INFO${END}] TTL DE $ttl_value SISTEMA OPERATIVO ${MAGENTA}LINUX${END}"
            else
                echo -e "[${MAGENTA}INFO${END}] TTL DE $ttl_value SISTEMA OPERATIVO ${MAGENTA}WINDOWS${END}"
            fi
        else
            echo -e "[${RED}FAIL${END}] ${RED}No se pudo determinar el TTL. Verifica la conectividad.${END}"
        fi
    else
        echo -e "[${RED}FAIL${END}] ${RED}No se pudo realizar el ping. Verifica la conectividad.${END}"
    fi
    nmap -O --osscan-guess $1 | grep -i "\bOS\b" | grep -v nmap
}

show_wifi(){
	echo -e "\n[${ORANGE}PI-005${END}] ${BLUE}DETECCION Y EXPLORACION DE ENCRIPTACION EN REDES WIFI${END}"
	echo -e "[${MAGENTA}INFO${END}] EL DISPOSITIVO SE ENCUENTRA CONECTADO EN LA RED ${MAGENTA}$(nmcli connection show --active | awk '{print $1}' | head -n2 | grep -v NAME)${END} A TRAVEZ DE ${MAGENTA}$(nmcli connection show --active | awk '{print $3}' | head -n2 | grep -v TYPE)${END}" 
	nmcli dev wifi list | head -n 15
}

web_identification(){
    echo -e "\n[${ORANGE}PI-006${END}] ${BLUE}IDENTIFICACION Y EXPLORACION DE APLICACIONES WEB${END}"
	cat evidence/ports_$1 | grep "http" &>/dev/null
	if [ $? -eq 0 ];then
		http_ports=$(cat evidence/ports_$1 | grep "http" | awk '{print $1, $3}' | grep -vi not | grep http | awk -F '/' '{print $1}')

		for i in $http_ports;do
			if [ $i -eq 443 ];then
				whatweb https://$1
			fi
			whatweb http://$1:$i
		done
	else
		echo -e "[${RED}FAIL${END}] ${RED}NO SE IDENTIFICARON SERVICIOS HTTP HABIERTOS${END}"
	fi
}

vuln_scann(){
	echo -e "\n[${ORANGE}PI-009 | PI-018 | PI-019 | PI-020 | PI-024 | PI-034 | PI-035 | PI-036 | PI-037${END}] ${BLUE}IDENTIFICACION Y ESCANEO DE VULNERABILIDADES${END}"
	echo -e "[${MAGENTA}INFO${END}] ESCANEANDO VULNERABILIDADES COMUNES${END}"
	ports=$(cat evidence/ports_$1 | grep "tcp" | awk '{print $1}' | grep -vi not | sed 's#/tcp##' | paste -sd ',')
	nmap --script vuln -p $ports $1 -oN evidence/vulns_$1 &>/dev/null
	cat evidence/vulns_$1 | grep -vi nmap | grep -v '#'

	cat evidence/vulns_$1 | grep CVE &>/dev/null
	if [ $? -eq 0 ];then
		for i in $(cat evidence/vulns_$1 | grep CVE | grep -oP '\(.*?\)' | tr -d '()');do
			echo -e "[${MAGENTA}INFO${END}] VEASE: ${MAGENTA}https://nvd.nist.gov/vuln/detail/$i${END}"
		done 
	fi
}

sniffing(){
	echo -e "\n[${ORANGE}PI-013 | PI-015${END}] ${BLUE}CAPTURA DE INFORMACION SENSIBLE EN LA RED (SNIFFING)${END}"
	echo -e "[${MAGENTA}INFO${END}] SNIFFING DE DATOS SENSIBLES POR ${MAGENTA}HTTP${END}"
	xterm -hold -title 'Sniffing de Red' -e "tshark -i $2 -Y 'http.request' -T fields -e http.host -e http.request.uri -e http.file_data -e http.authorization 2>/dev/null" &
}

spoofing(){
	echo -e "\n[${ORANGE}PI-014${END}] ${BLUE}MAC SPOOFING${END}"
	# Mostrar dirección MAC actual
	echo -e "[${MAGENTA}INFO${END}] Dirección MAC actual de $1:"
	ifconfig $1 | grep -i ether

	# Desactivar la interfaz antes de cambiar la MAC
	echo -e "[${MAGENTA}INFO${END}] Desactivando la interfaz $1..."
	sudo ifconfig $1 down

	# Cambiar la dirección MAC a una aleatoria usando macchanger
	echo -e "[${MAGENTA}INFO${END}] Cambiando la dirección MAC de $1..."
	sudo macchanger -r $1

	# Volver a activar la interfaz
	echo -e "[${MAGENTA}INFO${END}] Activando la interfaz $1..."
	sudo ifconfig $1 up

	# Mostrar la nueva dirección MAC
	echo -e "[${MAGENTA}INFO${END}] Nueva dirección MAC de $1:"
	ifconfig $1 | grep -i ether

	# Verificar la conexión a internet con curl
	sleep 3
	echo -e "[${MAGENTA}INFO${END}] Verificando conexión a Internet..."
	curl -s https://www.google.com &>/dev/null

	# Comprobar el código de estado de la respuesta
	if [ $? -eq 0 ]; then
	    echo -e "[${GREEN}SUCCESS${END}] Spoofing exitoso. Conexión a Internet verificada."
	else
	    echo -e "[${RED}FAIL${END}] Spoofing fallido. No se puede verificar la conexión a Internet."
	fi
}

fuzzing(){
	echo -e "\n[${ORANGE}PI-021${END}] ${BLUE}FUZZING DE APLICACIONES WEB${END}"
	ports=$(cat evidence/ports_$1 | grep "tcp" | awk '{print $1}' | grep -vi not | sed 's#/tcp##' | paste -sd ',')
	nmap --script http-enum -p $ports $1 -oN evidence/fuzzing_$1 &>/dev/null
	cat evidence/fuzzing_$1 | grep -vi nmap | grep -v '#'
}

process(){
	if [ -d "evidence" ]; then
		:
	else
		mkdir evidence
	fi

	banner
	spoofing $2
	port_scann $1
	os_discovery $1
	show_wifi
	web_identification $1
	vuln_scann $1
	sniffing $1 $2
	fuzzing $1
}

parameter_counter=0

while getopts "i:t:h" arg; do
    case $arg in
        i) interface=$OPTARG; let parameter_counter+=1 ;;
        t) target=$OPTARG; let parameter_counter+=1 ;;
        h) helpPanel ;;
    esac
done

if [ $parameter_counter -eq 0 ] || [ -z "$interface" ] || [ -z "$target" ]; then
    helpPanel
else
    process "$target" "$interface"
fi
