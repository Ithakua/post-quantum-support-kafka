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
plt.xlabel('N Iteration')
plt.ylabel('Time (miliseconds)')

# Añadir una leyenda
plt.legend()

# Mostrar la gráfica
plt.grid(True)
plt.show()

# Calcular la mediana de todos los valores para cada índice
medians = df.median()

# Excluir el primer elemento (el número de iteraciones)
medians = medians.drop(df.columns[0])

# Crear una nueva figura para el diagrama de barras
plt.figure(figsize=(12, 6))

# Crear un diagrama de barras con las medianas
plt.bar(medians.index, medians.values)

# Añadir título y etiquetas
plt.title('Median Handshake Time')
plt.xlabel('N Iteration')
plt.ylabel('Time (miliseconds)')

# Rotar las etiquetas del eje x para evitar que se solapen
plt.xticks(rotation=45)

# Mostrar la gráfica
plt.grid(True)
plt.show()