
# # Comando para capturar el tráfico entre el broker y el cliente

# sudo tcpdump -i br-44286964819a -nn -s0 -w kafka_traffic.pcap port 9093

# # Comando para ver el rendimiento de in contenedor

# sudo docker exec -it kafka-broker bash
