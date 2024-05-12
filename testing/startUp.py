import subprocess
import sys
import os
import time

def execute_shell_script(script_name):
    subprocess.run(["sh", script_name])
    
def execute_bash_script(script_name):
    subprocess.run(["bash", script_name])

def execute_python_script(script_name):
    subprocess.run(["python3", script_name])

def execute_docker_compose():
    os.system("gnome-terminal --title=DockerCompose_UP -- bash -c 'sudo docker compose -f docker-compose.yaml up; exec bash'")

def certificates_exist():
    return os.path.exists('../certificates/broker/broker.keystore.pkcs12')

def loading_bar(seconds):
    for i in range(seconds):
        sys.stdout.write('#')
        sys.stdout.flush()
        time.sleep(1)
    print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Elige el modo de ejecucion: clientAuth o performanceTest")
        sys.exit(1)

    parametro = sys.argv[1]

    if certificates_exist():
        print("Los certificados ya existen. No se ejecutará el script.")
        sys.exit(1)

    if parametro == "normal":
        execute_shell_script("./scripts/auto_certificates_normal.sh")
    elif parametro == "testing":
        execute_shell_script("./scripts/auto_certificates_testing.sh")
    # elif parametro == "pqc":
    #     execute_shell_script("./scripts/auto_certificates_pqc.sh")
    else:
        print("Parámetro de entrada no válido.")
        sys.exit(1)

    execute_docker_compose()

    if parametro == "testing":
        print("Esperando a levantar el servidor antes de ejecutar las pruebas...")
        loading_bar(15)
        execute_bash_script("./scripts/performance_test.sh")