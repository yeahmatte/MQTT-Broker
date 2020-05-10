import toml
import os.path
import os

install_file_path = './install_tools/install.toml'

install_toml = None

if os.path.isfile(install_file_path):
    with open(install_file_path) as f:
        install_toml = toml.load(f)
        f.close()
else:
    print("No install config file")
    exit(0)

if install_toml is None:
    print("No install config file")
    exit(0)

from download_config import get_file

for file in install_toml:
    get_file(install_toml[file]['file_path'], install_toml[file]['file_id'])


cert_config_path = './install_tools/cert_config.toml'
if os.path.isfile(cert_config_path):
    with open(cert_config_path) as f:
        cert_config = toml.load(f)
        f.close()

with open('docker-compose-template.yml', 'r') as file :
  filedata = file.read()
  file.close()

if "domain" in cert_config:
    if "domain_name" in cert_config["domain"]:
        # Replace the target string
        filedata = filedata.replace('YOUR_DOMAIN_HERE', cert_config["domain"]["domain_name"])
    if "domain_email" in cert_config["domain"]:
        # Replace the target string
        filedata = filedata.replace('YOUR_DOMAIN_EMAIL', cert_config["domain"]["domain_email"])
    if "cert_path" in cert_config["domain"]:
        # Replace the target string
        filedata = filedata.replace('YOUR_CERT_PATH', cert_config["domain"]["cert_path"])

os.environ['CERTPATH'] = cert_config["domain"]["cert_path"]

# Write the file out again
with open('docker-compose.yml', 'w') as file:
  file.write(filedata)
  file.close()
