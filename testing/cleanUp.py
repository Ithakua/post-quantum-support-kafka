import subprocess
import os

def execute_shell_script(script_name):
    subprocess.run(["sh", script_name])

def confirm_execution():
    confirmation = input("You are about to run a script that will clean up the files. Do you wish to continue? (y/n): ")
    return confirmation.lower() == 's' or confirmation.lower() == 'y'

def clean_files():
    if confirm_execution():
        try:
            execute_shell_script("./scripts/cleanFiles.sh")
            print("All certificates and test files have been deleted")
            if os.path.exists("docker-compose.yaml"):
                os.remove("docker-compose.yaml")
                print("The docker-compose.yaml file has been deleted")
            else:
                print("The docker-compose.yaml file does not exist")
        except subprocess.CalledProcessError as e:
            print(f"Error executing the script ./cleanFiles.sh: {e}")
        except OSError as e:
            print(f"Error deleting the docker-compose.yaml file: {e}")
    else:
        print("Operation cancelled")

clean_files()