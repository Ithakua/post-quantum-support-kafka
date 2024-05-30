# Post-Quantum Support Kafka

## Descripción del Proyecto

Este repositorio contiene un trabajo final de grado y su propósito es ofrecer una infraestructura básica funcional de Apache Kafka con soporte de criptografía post-cuántica utilizando la librería de [Bouncy Castle](https://github.com/bcgit/bc-java/tree/main). 

La estructura del proyecto es la siguiente:

- **KafkaApp**: Una aplicación cliente que proporciona un productor que recibe mensajes del tipo **String** a través de un endpoint que acepta peticiones **POST** con un **JSON** en de la forma `"message": <mensaje de ejemplo del tipo String>`, y un consumidor que lee los mensajes generados por el productor y los imprime como logs por la consola.
- **testing**: Directorio que actua como un centro de control, es donde se lanzan todos los comandos para preparar la infraestructura servidor de Kafka y donde poder ejecutar los scripts que permiten monitorear la infraestructura para estudiar su funcionamiento.
- **certificates**: Carpeta donde se guardan todos los ficheros relacionados con los certificados del cliente, el broker y la CA.
- **docker**: Directorio que contiene las plantillas docker-compose.yaml que se utilizarán para lanzar el zookeeper y el servidor de kafka, también se pueden encontrar ficheros de configuración para pruebas.

## Cómo desplegar el servidor

Para lanzar el servidor de Kafka junto con Zookeeper, sigue estos pasos:

1. Descarga el repositorio `<Nombre del repositorio>` y accede a la carpeta `testing`.

2. Dentro de `testing`, ejecuta el comando `python3 cleanUp.py` para limpiar todos los archivos residuales, si los hubiera.

3. Ejecuta `python3 startUp.py <modo de ejecucion>`, donde `<modo de ejecucion>` puede tener tres valores:

    - `default`: Despliega un broker de Kafka con la configuración por defecto sin ningún proveedor de seguridad personalizado. 
    - `mlkem`: Despliega un broker con un proveedor SSL personalizado que utiliza el **BouncyCastleJSSEProvider** y que utiliza únicamente conexiones con los grupos `kyber512`, `kyber768` y `kyber1024`.
    - `allgroups`: Despliega un broker con un proveedor SSL personalizado que utiliza el **BouncyCastleJSSEProvider** y que genera conexiones utilizando algoritmos criptográficos como `x448`, `x22519`, `P256`, `P384`, `p521` junto con los grupos `kyber512`, `kyber768` y `kyber1024`.

Al ejecutar el script, se preparan para su uso los ficheros `docker-compose.yaml` disponibles en la carpeta `./docker`, se generarán los certificados necesarios y se lanzará un terminal donde se ejecutará el comando `docker compose up`.

Todos los modos crean los certificados necesarios dentro del directorio `./certificates` y los firma por una CA autogenerada. Los grupos utilizados se pueden modificar y cambiar si también se utilizan las herramientas disponibles en el repositorio **SecurityCustomProvider** (más detalles en su repositorio).

## Cómo desplegar el cliente

Para lanzar el cliente de Kafka, primero necesitarás lanzar el servidor junto con Zookeeper. Después, sigue estos pasos:

1. Dentro del repositorio, encontrarás una carpeta llamada `KafkaApp`. Este es un proyecto Java Spring Boot que tiene lo necesario para establecer una conexión SSL personalizada con el servidor Kafka. Abre este proyecto con tu IDE de preferencia (yo utilicé IntelliJ).

2. Una vez abierto el proyecto, descargar todas las dependencias de Maven y añadir adicionalmente el `.jar` que se encuentra en el directorio `/KafkaApp/libs` en función del modo de utilización del servidor:
    - **SecurityCustomProvider_MLKEM** para configurar el cliente únicamente con conexiones MLKEM.
    - **SecurityCustomProvider_AllGroups** para cargar la configuración necesaria para establecer conexiones tanto MLKEM como KEM clásicas.

### Consideraciones importantes

_La aplicación utiliza Lombok y se necesita Java 21 para poder ejecutar la aplicación._

## Cómo utilizar las herramientas de monitoreo

Las herramientas incluidas en el proyecto se despliegan todas desde el directorio `testing`, donde además se guardarán los ficheros tales como capturas de tráfico, `.csv` y `docker-compose.yaml`. Las herramientas disponibles son las siguientes:

- `python3 monitor.py <utilidad>`: Este script es el encargado de lanzar las utilidades que acceden a los scripts encargados del monitoreo. Las utilidades disponibles son:
    - `tcpdump`: Con este parámetro, se lanza una terminal con un capturador de tráfico que escucha las conexiones SSL del broker (servidor).
    - `health`: Se utiliza para medir el rendimiento del contenedor donde está desplegado el broker.
    - `exec`: Este comando sirve para tener acceso al terminal del contenedor del broker.
    - `traffic`: Este parámetro permite sobrecargar de peticiones el endpoint del cliente para generar tráfico entre el cliente y el broker (se necesita tener en ejecución la aplicación cliente).
    - `graph`: Esta utilidad está reservada a graficar los resultados medidos del tiempo de handshake que se generan utilizando el repositorio `SecurityCustomProvider`.

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

- **pip3**: Si deseas utilizar el graficador para representar los resultados que se obtienen del SecurityCustomProvider, necesitarás instalar los siguientes paquetes de Python:

```sh
pip3 install pandas matplotlib


