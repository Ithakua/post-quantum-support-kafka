import subprocess
import sys
import os

def execute_shell_script(script_name):
    subprocess.run(["sh", script_name])

def execute_python_script(script_name):
    subprocess.run(["python3", script_name])

def execute_docker_compose():
    os.system("gnome-terminal --title=DockerCompose_UP -- bash -c 'sudo docker compose -f docker-compose.yaml up; exec bash'")

def certificates_exist():
    return os.path.exists('../certificates/broker/broker.keystore.pkcs12')


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Elige el modo de ejecucion: clientAuth o noClientAuth")
        sys.exit(1)

    parametro = sys.argv[1]

    if certificates_exist():
        print("Los certificados ya existen. No se ejecutará el script.")
        sys.exit(1)

    if parametro == "clientAuth":
        execute_shell_script("./scripts/auto_certificates_clientAuth.sh")
    elif parametro == "noClientAuth":
        execute_shell_script("./scripts/auto_certificates_noClientAuth.sh")
    elif parametro == "pqc":
        execute_shell_script("./scripts/auto_certificates_pqc.sh")
    else:
        print("Parámetro de entrada no válido.")
        sys.exit(1)

    execute_docker_compose()
