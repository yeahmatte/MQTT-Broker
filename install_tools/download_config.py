from googleapiclient import errors
from googleapiclient import http
from googleapiclient.discovery import build

import re
import os.path

api_key = None
api_key_file = './install_tools/apikey'

#https://drive.google.com/file/d/1HOf6pZrRKeRzo-LCRxCCfQ66YxXMrKUD/view?usp=sharing
#https://drive.google.com/file/d/1cJoVWIa5VdnZRxnoSBB0tQzM1CtkPGAB/view?usp=sharing
if os.path.isfile(api_key_file):
    with open(api_key_file) as f:
        api_key = f.readline()
        f.close()
        api_key = re.sub("\n|\r", "", api_key)
else:
    print("No api key")
    exit(0)

if api_key is None:
    exit(0)

config_service = build('drive', 'v3', developerKey=api_key)
#config_service = build('Summitmonster-Digitalhome', 'v2', developerKey=api_key)

def print_file_metadata(service, file_id):
    """Print a file's metadata.

    Args:
    service: Drive API service instance.
    file_id: ID of the file to print metadata for.
    """
    try:
        file = service.files().get(fileId=file_id).execute()
        print('Title: {}'.format(file['title']))
        print('MIME type: {}'.format(file['mimeType']))
    except errors.HttpError as error:
        print('An error occurred: {}'.fromat(error))


def print_file_content(service, file_id):
    """Print a file's content.

    Args:
      service: Drive API service instance.
      file_id: ID of the file.
    Returns:
      File's content if successful, None otherwise.
    """
    try:
        print(service.files().get_media(fileId=file_id).execute())
    except errors.HttpError as error:
        print('An error occurred: {}'.format(error))


def download_file(service, file_id, local_fd):
    """Download a Drive file's content to the local filesystem.

    Args:
      service: Drive API Service instance.
      file_id: ID of the Drive file that will downloaded.
      local_fd: io.Base or file object, the stream that the Drive file's
        contents will be written to.
    """
    request = service.files().get_media(fileId=file_id)
    media_request = http.MediaIoBaseDownload(local_fd, request)

    while True:
        try:
            download_progress, done = media_request.next_chunk()
        except errors.HttpError as error:
            print('An error occurred: {}'.format(error))
            return
        if download_progress:
            print('Download Progress: %d%%' % int(download_progress.progress() * 100))
        if done:
            print('Download Complete')
        return

def get_file(file_path, file_id):

    if not os.path.isfile(file_path):
        print("No file present at: {} ".format(file_path))

    with open(file_path, "wb") as f:
        file = download_file(config_service, file_id, f)
        print("File: {} updated".format(file_path))
        f.close()
