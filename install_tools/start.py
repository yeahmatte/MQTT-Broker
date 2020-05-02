import toml
import os.path

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

# read_compose_config
# replace
# Read in the file
with open('file.txt', 'r') as file :
  filedata = file.read()

# Replace the target string
filedata = filedata.replace('ram', 'abcd')

# Write the file out again
with open('file.txt', 'w') as file:
  file.write(filedata)
