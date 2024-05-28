import requests
import json
import time

# URL del endpoint KafkaApp
url = "http://localhost:8080/api/input/messages"

# Iniciar el cronómetro
start_time = time.time()

# Bucle para enviar 10000 peticiones POST
for i in range(1, 10001):
    # Estructura del body
    data = {
        "message": f"Otro mensaje a ver que pasa con ID: {i}"
    }

    response = requests.post(url, data=json.dumps(data), headers={'Content-Type': 'application/json'})

    # Imprimir el número de mensaje
    print(f"Enviando mensaje con ID: {i}")

    # Verificar si se completo la petición correctamente
    if response.status_code != 200:
        print(f"Error al enviar el mensaje con ID: {i}. Código de estado: {response.status_code}")

# Detener el cronómetro
end_time = time.time()

# Calcular e imprimir el tiempo total de ejecución
total_time = end_time - start_time
print(f"Tiempo total: {total_time} segundos")