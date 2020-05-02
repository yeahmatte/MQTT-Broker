import os.path
import re

api_key_path = "./install_tools/apikey"

if not os.path.isfile(api_key_path):
    apikey = input("Api key: ")

    with open(api_key_path, "w") as f:
        f.write(apikey)
        print("File: {} updated".format(api_key_path))
        f.close()

install_toml_id_path = "./install_tools/installid"
install_toml_id = None

if not os.path.isfile(install_toml_id_path):
    install_toml_id = input("install toml id: ")

    with open(install_toml_id_path, "w") as f:
        f.write(install_toml_id)
        print("File: {} updated".format(install_toml_id_path))
        f.close()
elif os.path.isfile(install_toml_id_path):
    with open(install_toml_id_path) as f:
        install_toml_id = f.readline()
        f.close()
        install_toml_id = re.sub("\n|\r", "", install_toml_id)
else:
    print("No install toml id")
    exit(0)

from download_config import get_file

install_file_path = './install_tools/install.toml'

get_file(install_file_path, install_toml_id)
