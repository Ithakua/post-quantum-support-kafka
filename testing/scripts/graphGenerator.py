import pandas as pd
import matplotlib.pyplot as plt

# Leer el archivo CSV
df = pd.read_csv('handshake_times.csv')

# Mostrar la cabecera del DataFrame para verificar los datos
print(df.head())

# Configurar la gráfica
plt.figure(figsize=(12, 6))

# Iterar sobre las columnas (exceptuando la primera columna que es el índice)
for column in df.columns[1:]:
    plt.plot(df.index, df[column], label=column)

# Añadir título y etiquetas
plt.title('Handshake Time')
plt.xlabel('Iteration Number')
plt.ylabel('Time (seconds)')

# Añadir una leyenda
plt.legend()

# Mostrar la gráfica
plt.grid(True)
plt.show()
