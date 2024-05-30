# Post-Quantum Support Kafka

Este repositorio contiene un trabajo final de grado y su propósito es ofrecer una infraestructura básica funcional de [Apache Kafka](https://kafka.apache.org/) con soporte de criptografía post-cuántica utilizando la librería [Bouncy Castle](https://www.bouncycastle.org/). 

## ¿Qué contiene el repositorio?

La estructura del repositorio es la siguiente:

- **KafkaApp**: Una aplicación Springboot que proporciona un cliente Kafka. Ofrece un productor que recibe mensajes del tipo **String** a través de un endpoint que acepta peticiones **POST** con un **JSON** en de la forma `"message": <mensaje de ejemplo del tipo String>`, y un consumidor que lee los mensajes generados por el productor y los imprime como logs por la consola.
- **testing**: Directorio que actua como un centro de control, es donde se lanzan todos los comandos para preparar la infraestructura servidor de Kafka y donde poder ejecutar los scripts que permiten monitorear la infraestructura para estudiar su funcionamiento.
- **certificates**: Carpeta donde se guardan todos los ficheros relacionados con los certificados del cliente, el broker y la CA.
- **docker**: Directorio que contiene las plantillas docker-compose.yaml que se utilizarán para lanzar el zookeeper y el servidor de kafka, también se pueden encontrar ficheros de configuración para pruebas.

## Cómo desplegar el servidor

Para lanzar el servidor de Kafka junto con Zookeeper, sigue estos pasos:

1. Descarga el repositorio `post-quantum-support-kafka` y accede a la carpeta `./testing`.

2. Dentro del directorio `./testing`, ejecuta el comando `python3 cleanUp.py` para limpiar todos los archivos residuales, si los hubiera.

3. Ejecuta `python3 startUp.py <modo de ejecucion>`, donde `<modo de ejecucion>` puede tener tres valores:

    - `default`: Despliega un broker de Kafka con la configuración por defecto sin ningún proveedor de seguridad personalizado. 
    - `mlkem`: Despliega un broker con un proveedor SSL personalizado que utiliza el **BouncyCastleJSSEProvider** y que utiliza únicamente conexiones con los grupos _kyber512_, _kyber768_ y _kyber1024_.
    - `allgroups`: Despliega un broker con un proveedor SSL personalizado que utiliza el **BouncyCastleJSSEProvider** y que genera conexiones utilizando algoritmos KEM Clásicos como _x448_, _x22519_, _P256_, _P384_, _p521_ junto con los grupos ML-KEM _kyber512_, _kyber768_ y _kyber1024_.

Al ejecutar el script, se preparan para su uso los ficheros `docker-compose.yaml` disponibles en la carpeta `./docker`, se generarán los certificados necesarios y se lanzará un terminal donde se ejecutará el comando `docker compose up`.

### Consideraciones importantes

_Todos los modos crean los certificados necesarios dentro del directorio `./certificates` y los firma por una CA autogenerada. Los grupos utilizados se pueden modificar y cambiar si también se utilizan las herramientas disponibles en el repositorio [custom-security-provider-kafka](https://github.com/Ithakua/custom-security-provider-kafka) (más detalles en el repositorio)._

## Cómo desplegar el cliente

Para lanzar el cliente de Kafka, primero necesitarás haber lanzado el servidor. Después, sigue estos pasos:

1. Dentro del repositorio, encontrarás una carpeta llamada `./KafkaApp`. Este directorio contiene un proyecto **Java SpringBoot** que tiene lo necesario para establecer una conexión SSL personalizada con el servidor Kafka. Abre este proyecto con tu IDE de preferencia (yo utilicé IntelliJ).

2. Una vez abierto el proyecto, descargar todas las dependencias de Maven y añadir adicionalmente el `.jar` que se encuentra en el directorio `./KafkaApp/libs` en función del modo de utilización del servidor:
    - **CustomSecurityProvider_mlkem** para configurar el cliente únicamente con conexiones MLKEM.
    - **CustomSecurityProvider_allgroups** para cargar la configuración necesaria para establecer conexiones tanto MLKEM como KEM clásicas.

### Consideraciones importantes

_La aplicación utiliza Lombok y se necesita Java 21 para poder ejecutar la aplicación._

## Cómo utilizar las herramientas de monitoreo

Las herramientas incluidas en el proyecto se despliegan todas desde el directorio `./testing`, dirección donde además se guardarán los ficheros tales como capturas de tráfico `.pcap`, `.csv` y `docker-compose.yaml`. Las herramientas disponibles son las siguientes:

- `python3 monitor.py <utilidad>`: Este script es el encargado de lanzar las utilidades que acceden a los scripts encargados del monitoreo. Las utilidades disponibles son:
    - `tcpdump`: Con este parámetro, se lanza una terminal con un capturador de tráfico que escucha las conexiones SSL del broker (servidor).
    - `health`: Se utiliza para medir el rendimiento del contenedor donde está desplegado el broker.
    - `exec`: Este comando sirve para tener acceso al terminal del contenedor del broker.
    - `traffic`: Este parámetro permite sobrecargar de peticiones el endpoint del cliente para generar tráfico entre el cliente y el broker (se necesita tener en ejecución la aplicación cliente).
    - `graph`: Esta utilidad está reservada a graficar los resultados medidos del tiempo de handshake que se generan utilizando el repositorio `custom-security-provider-kafka`.

- `python3 startUp.py <modo de ejecución>`: Como se explica en el apartado "Cómo desplegar el servidor", tiene tres modos de funcionamiento:
    - `default`: Configuración estándar.
    - `mlkem`: Configuración personalizada MLKEM.
    - `allgroups`: Configuración híbrida con algoritmos KEM clásicos y MLKEM.

- `python3 cleanUp.py`: Este script se encarga de limpiar todos los ficheros de prueba, certificados (incluido la CA) y el `docker-compose.yaml`, dejando el entorno para ejecutarse de nuevo.

## Requisitos

Para poder utilizar este proyecto, es necesario tener instalados los siguientes componentes:

### Necesarios

- **Docker Utilities**: Incluyendo Docker y Docker Compose.
- **Git**: Para clonar y gestionar repositorios remotos de GitHub.
- **Java 21**: Para ejecutar la aplicación cliente de Kafka.
- **Plugin Lombok**: Necesario para la aplicación cliente.
- **Python 3**: Para ejecutar los scripts proporcionados en el proyecto.

### Opcionales

- **Herramienta para visualizar archivos .pcap**: Necesaria para leer las capturas de tráfico de red, como Wireshark.

- **[custom-security-provider-kafka](https://github.com/Ithakua/custom-security-provider-kafka)**: Repositorio adicional con las herramientas necesarias para generar tus propios proovedores de seguridad personalizados y medir sus tiempos de handshake.

- **pip3**: Si deseas utilizar el graficador para representar los resultados que se obtienen del CustomSecurityProvider (aplicación del repositorio custom-security-provider-kafka), necesitarás instalar los siguientes paquetes de Python:

```
pip3 install pandas matplotlib
```