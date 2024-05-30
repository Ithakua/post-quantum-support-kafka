# Post-Quantum Support Kafka

This repository is part of a Bachelor Thesis focused on providing a basic functional infrastructure of [Apache Kafka](https://kafka.apache.org/) with post-quantum cryptography support using the [Bouncy Castle](https://www.bouncycastle.org/) library.

## What's in the repository?

The repository structure is as follows:

- **KafkaApp**: A Spring Boot application that provides a Kafka client. It includes a producer that receives **String** type messages through an endpoint accepting **POST** requests with a **JSON** formatted as `"message": <sample string message>`, and a consumer that reads the messages generated by the producer and prints them as logs to the console.
- **testing**: Directory that acts as a control center, where all commands to set up the Kafka server infrastructure are launched and where scripts for monitoring the infrastructure can be executed to study its performance.
- **certificates**: Folder where all files related to client, broker, and CA certificates are stored.
- **docker**: Directory containing docker-compose.yaml templates used to launch Zookeeper and the Kafka server, as well as configuration files for testing.

## How to deploy the server

To launch the Kafka server along with Zookeeper, follow these steps:

1. Download the `post-quantum-support-kafka` repository and navigate to the `./testing` folder.

2. Inside the `./testing` directory, run the command `python3 cleanUp.py` to clean up any residual files, if any.

3. Execute `python3 startUp.py <execution_mode>`, where `<execution_mode>` can have three values:

    - `default`: Deploys a Kafka broker with default configuration without any custom security provider.
    - `mlkem`: Deploys a broker with a custom SSL provider using **BouncyCastleJSSEProvider** and only connections with groups _kyber512_, _kyber768_, and _kyber1024_.
    - `allgroups`: Deploys a broker with a custom SSL provider using **BouncyCastleJSSEProvider** and connections using both classic KEM algorithms like _x448_, _x22519_, _P256_, _P384_, _p521_ and ML-KEM groups _kyber512_, _kyber768_, and _kyber1024_.

When the script runs, it prepares the `docker-compose.yaml` files available in the `./docker` folder, generates the necessary certificates, and launches a terminal where the `docker compose up` command will be executed.

### Important Considerations

_All modes create the necessary certificates inside the `./certificates` directory and sign them with a self-generated CA. The groups used can be modified if the tools available in the [custom-security-provider-kafka](https://github.com/Ithakua/custom-security-provider-kafka) repository are also used (more details in the repository)._

## How to deploy the client

To launch the Kafka client, you first need to have the server running. Then, follow these steps:

1. In the repository, find a folder called `./KafkaApp`. This directory contains a **Java SpringBoot** project that has everything necessary to establish a custom SSL connection with the Kafka server. Open this project with your preferred IDE (I used IntelliJ).

2. Once the project is open, download all Maven dependencies and additionally add the `.jar` found in the `./KafkaApp/libs` directory based on the server execution mode:
    - **CustomSecurityProvider_mlkem** to configure the client with only MLKEM connections.
    - **CustomSecurityProvider_allgroups** to load the necessary configuration to establish both MLKEM and classic KEM connections.

### Important Considerations

_The application uses Lombok and requires Java 21 to run._

## How to use the monitoring tools

The tools included in the project are all deployed from the `./testing` directory, where files such as `.pcap` traffic captures, `.csv` files, and `docker-compose.yaml` will be stored. The available tools are as follows:

- `python3 monitor.py <utility>`: This script is responsible for launching the utilities that access the scripts for monitoring. The available utilities are:
    - `tcpdump`: Launches a terminal with a traffic capturer that listens to the SSL connections of the broker (server).
    - `health`: Measures the performance of the container where the broker is deployed.
    - `exec`: Provides access to the broker container terminal.
    - `traffic`: Overloads the client's endpoint with requests to generate traffic between the client and the broker (requires the client application to be running).
    - `graph`: Reserved for graphing the handshake time results generated using the `custom-security-provider-kafka` repository.

- `python3 startUp.py <execution_mode>`: As explained in the "How to deploy the server" section, it has three modes of operation:
    - `default`: Standard configuration.
    - `mlkem`: Custom MLKEM configuration.
    - `allgroups`: Hybrid configuration with classic KEM and MLKEM algorithms.

- `python3 cleanUp.py`: This script cleans up all test files, certificates (including the CA), and the `docker-compose.yaml`, leaving the environment ready for a new run.

## Requirements

To use this project, you need to have the following components installed:

### Necessary

- **Docker Utilities**: Including Docker and Docker Compose.
- **Git**: To clone and manage remote GitHub repositories.
- **Java 21**: To run the Kafka client application.
- **Lombok Plugin**: Necessary for the client application.
- **Python 3**: To run the scripts provided in the project.

### Optional

- **[custom-security-provider-kafka](https://github.com/Ithakua/custom-security-provider-kafka)**: Additional repository containing the CustomSecurityProvider, with tools needed to generate your own custom security providers and measure their handshake times.

- **pcap visualizer**: Necessary to read network traffic captures, such as Wireshark.

- **pip3**: If you want to use the graphing tool to represent the results obtained from the CustomSecurityProvider, you will need to install the following Python packages:
