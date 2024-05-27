import requests
import json

# URL a la que se enviarán las peticiones POST
url = "http://localhost:8080/api/v2/messages"

# Bucle para enviar 1000 peticiones POST
for i in range(1, 100001):
    # Cuerpo de la petición
    data = {
        "message": f"Otro mensaje a ver que pasa con ID: {i}"
    }

    # Enviar la petición POST
    response = requests.post(url, data=json.dumps(data), headers={'Content-Type': 'application/json'})

    # Imprimir el número de mensaje que se está enviando
    print(f"Enviando mensaje con ID: {i}")

    # Verificar si la petición fue exitosa
    if response.status_code != 200:
        print(f"Error al enviar el mensaje con ID: {i}. Código de estado: {response.status_code}")