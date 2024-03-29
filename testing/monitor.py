import subprocess
import json

import subprocess
import json

# Comando para obtener la información del contenedor kafka_broker
command1_0 = "sudo docker inspect kafka-broker"
output1_0 = subprocess.check_output(command1_0, shell=True)
json_data = json.loads(output1_0)[0]
ip_address = json_data['NetworkSettings']['Networks']['testing_kafka-net']['IPAddress']

# Comando para obtener la lista de interfaces de red
command1_1 = "ip addr"
output1_1 = subprocess.check_output(command1_1, shell=True).decode()
lines = output1_1.split('\n')

# Buscar la interfaz de red correspondiente a los dos primeros segmentos de la IP del contenedor
ip_segments = ip_address.split('.')[:2]
for line in lines:
    if all(segment in line for segment in ip_segments):
        interface = line.split()[-1]

# Comprobar si se encontró una interfaz de red
if interface is None:
    print(f"No se encontró ninguna interfaz de red con la dirección IP {ip_address}")
else:
    # Comando para capturar el tráfico entre el broker y el cliente
    command2 = f"sudo tcpdump -i {interface} -nn -s0 -w kafka_traffic.pcap port 9093"
    subprocess.Popen(['gnome-terminal', '--title= TCP DUMP', '--', 'bash', '-c', f'{command2}; exec bash'])

# Comando para ver el rendimiento de un contenedor
command3 = "sudo docker stats kafka-broker"
subprocess.Popen(['gnome-terminal', '--title= Container Performance', '--', 'bash', '-c', f'{command3}; exec bash'])

# Comando para meterte dentro del contenedor de kafka
command4 = "sudo docker exec -it kafka-broker bash"
subprocess.Popen(['gnome-terminal', '--title= Exec Terminal', '--', 'bash', '-c', f'{command4}; exec bash'])