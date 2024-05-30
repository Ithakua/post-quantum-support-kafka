import subprocess
import os

def execute_shell_script(script_name):
    subprocess.run(["sh", script_name])

def confirm_execution():
    confirmation = input("Estás a punto de ejecutar un script que limpiará los archivos. ¿Deseas continuar? (s/n): ")
    return confirmation.lower() == 's' or confirmation.lower() == 'y'

def clean_files():
    if confirm_execution():
        try:
            execute_shell_script("./scripts/cleanFiles.sh")
            print("Se eliminaron todos los certificados y los ficheros de test")
            if os.path.exists("docker-compose.yaml"):
                os.remove("docker-compose.yaml")
                print("Se eliminó el archivo docker-compose.yaml")
            else:
                print("El archivo docker-compose.yaml no existe")
        except subprocess.CalledProcessError as e:
            print(f"Error ejecutando el script ./cleanFiles.sh: {e}")
        except OSError as e:
            print(f"Error eliminando el archivo docker-compose.yaml: {e}")
    else:
        print("Operación cancelada")

clean_files()