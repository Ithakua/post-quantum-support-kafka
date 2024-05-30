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
        print("Choose the execution mode: default, mlkem or allgroups")
        sys.exit(1)

    parametro = sys.argv[1]

    if certificates_exist():
        print("Certificates already exist. The script will not be executed.")
        sys.exit(1)

    if parametro == "mlkem":
        execute_shell_script("./scripts/auto_certificates_mlkem.sh")
    elif parametro == "allgroups":
        execute_shell_script("./scripts/auto_certificates_allgroups.sh")
    elif parametro == "default":
        execute_shell_script("./scripts/auto_certificates_default.sh")
    else:
        print("Invalid input parameter.")
        sys.exit(1)

    execute_docker_compose()