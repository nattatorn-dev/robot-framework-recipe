import requests


def upload_file(endpoint_url, file_name, file_path, file_type):
    url = endpoint_url
    payload = {}
    files = {'file': (file_name, open(file_path, 'rb'),
                      file_type, {'Expires': '0'})}
    response = requests.post(url, files=files, data=payload)
    return response
