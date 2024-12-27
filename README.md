# Bienvenido a DMQ PWN TOOL
Esta herramienta ha sido especialmente diseñada para automatizar el listado de requerimientos de pruebas a realizar en las auditorías de seguridad internas de DMQ. Su principal objetivo es simplificar el trabajo de los auditores de seguridad al recopilar la mayoría de las pruebas de explotación, generandoevidencias concretas que pueden ser utilizadas posteriormente en los informes técnicos.

<p align="center">
	<img src="https://i.imgur.com/n9ukLuA.png" width="100%" height="100%" align="">
</p>

## Instrucciones

Ejecute este *script* como **root** y utilize el parámetro `-h` para desplegar el manual de ayuda, dentro del mismo se encuentran las opciones:
-  **-h**: Muestra este panel de ayuda.
-  **-t**: Especifica el target objetivo.
-  **-i**: Especifica la interfaz de red para el sniffing.
## Dependencias

Antes de utilizar la herramienta es necesario instalar las dependencias correspondientes para que el mismo funcione en su totalidad. Cada una de estas puede ser instalada utilizando el comando *supo apt install \<NOMBRE DE LA DEPENDENCIA\>* dependiendo si se encuentra en alguna distribución de Linux basada en *Debian* o *Ubuntu*.
- **nmap**
- **tshark**
- **whatweb**
- **macchanger**
- **net-tools**
- **curl**
## Tabla Pruebas Internas

La tabla a continuación presenta cada uno de los lineamientos o pruebas que deben seguirse en las auditorías internas. Cada código identificador corresponde a un tipo de prueba, el cual se detalla durante la ejecución de la herramienta. En el apartado de generación de evidencias, el programa almacena todos los datos de las pruebas en bruto dentro de la carpeta **evidence**. Alternativamente, el propio _output_ mostrado en consola constituye una evidencia más procesada y detallada.

Cabe destacar que algunas pruebas no pudieron implementarse en su totalidad debido a su complejidad, la disponibilidad del cliente y los posibles problemas severos que podrían ocasionar, como denegaciones de servicio, daños internos o interferencias en la red.

| Código | Descripción                                                                                                                                                                                           | Implementado | Motivo                                        |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------------------------------------- |
| PI-001 | Enumeración y Análisis de Vulnerabilidades Interno.                                                                                                                                                   | SI           | -                                             |
| PI-002 | Análisis y Escaneo de Puertos.                                                                                                                                                                        | SI           | -                                             |
| PI-003 | Detección y Análisis de Servicios Activos.                                                                                                                                                            | SI           | -                                             |
| PI-004 | Detección Remota de SO.                                                                                                                                                                               | SI           | -                                             |
| PI-005 | Detección y Exploración de Encriptación de Redes WIFI.                                                                                                                                                | SI           | -                                             |
| PI-006 | Identificación y Exploración de Aplicaciones Web.                                                                                                                                                     | SI           | -                                             |
| PI-007 | Generación de Evidencia.                                                                                                                                                                              | SI           | -                                             |
| PI-008 | Escalada de Privilegios.                                                                                                                                                                              | NO           | Puede Causar Daños Internos.                  |
| PI-009 | Explotación de Vulnerabilidades Detectadas.                                                                                                                                                           | SI           | -                                             |
| PI-010 | Hardening.                                                                                                                                                                                            | NO           | Complejidad.                                  |
| PI-011 | Pruebas de penetración a equipos de red, equipos de seguridad, sistemas operativos, aplicaciones de red, y aplicaciones web de forma controlada y sin comprometer la infromación.                     | NO           | Debe hacerse manualmente.                     |
| PI-012 | Pruebas de cracking por fuerza bruta sobre aplicaciones de administración y acceso remoto a equipos de networking, equipos de seguridad, sistemas operativos, aplicaciones de red y aplicaciones web. | NO           | Debe hacerse manualmente.                     |
| PI-013 | Captura de Información Sensible en la Red (Sniffing).                                                                                                                                                 | SI           | -                                             |
| PI-014 | Ataques de Inundación de Tráfico, envenenamiento y spoofing.                                                                                                                                          | SI           | -                                             |
| PI-015 | Utilización de Exploits preparados y diseñados para robo de Información.                                                                                                                              | SI           | -                                             |
| PI-016 | Ataques de Robo de Sesiones.                                                                                                                                                                          | NO           | Debe hacerse manualmente.                     |
| PI-017 | Hacking Wireless.                                                                                                                                                                                     | NO           | Lleva mucho tiempo, debe hacerse manualmente. |
| PI-018 | Hacking de Base de Datos.                                                                                                                                                                             | SI           | -                                             |
| PI-019 | SQL Injection.                                                                                                                                                                                        | SI           | -                                             |
| PI-020 | Ataques (XSS y CSRF.F31).                                                                                                                                                                             | SI           | -                                             |
| PI-021 | Fuzzing de Aplicaciones Web.                                                                                                                                                                          | SI           | -                                             |
| PI-022 | Banner Grabbing.                                                                                                                                                                                      | SI           | -                                             |
| PI-023 | Ataques de Overflow.                                                                                                                                                                                  | NO           | Puede Causar Daños Internos.                  |
| PI-024 | Cross Site Request Forgery (CSRF).                                                                                                                                                                    | SI           | -                                             |
| PI-025 | Escalamiento de Privilegios.                                                                                                                                                                          | NO           | Puede Causar Daños Internos.                  |
| PI-026 | Suplantación de Credenciales.                                                                                                                                                                         | NO           | Debe hacerse manualmente.                     |
| PI-027 | Detección de Conexiones Externas.                                                                                                                                                                     | NO           | Lleva mucho tiempo, debe hacerse manualmente. |
| PI-028 | Usuarios y Claves Quemadas en la Aplicación.                                                                                                                                                          | NO           | Debe hacerse manualmente.                     |
| PI-029 | Ataques a la Aplicación Web con los privilegios de un Usuario Autorizado.                                                                                                                             | NO           | Debe hacerse manualmente.                     |
| PI-030 | Ataques Vlan Hooping.                                                                                                                                                                                 | -            | En Proceso.                                   |
| PI-031 | Ataques Vlan Double Tagging.                                                                                                                                                                          | -            | En Proceso.                                   |
| PI-032 | Ataques sobre Spanning Tree Protocol.                                                                                                                                                                 | -            | En Proceso.                                   |
| PI-033 | Ataques sobre Protocolos de Capa 2 y 3.                                                                                                                                                               | No           | Puede Causar Interferencia de Red.            |
| PI-034 | Ataques sobre Código HTML, PHP, generado por la aplicación.                                                                                                                                           | SI           | -                                             |
| PI-035 | Ataques sobre componentes JAVA/ActiveX, Flash y AJAX.                                                                                                                                                 | SI           | -                                             |
| PI-036 | Ataques Command Execution.                                                                                                                                                                            | SI           | -                                             |
| PI-037 | Verificación y Explotación Controlada de las Vulnerabilidades.                                                                                                                                        | SI           | -                                             |
