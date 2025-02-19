# Curl Wrapper

A simple bash script that i use to help automate my curl scans

## Features
- The script will attempt to make connection at least 3 times
- Responses are then saved to a .txt file under response_body.txt
- The Request log is saved in log file curl_requests.log

## Installation:
```sh
git clone https://github.com/bluechipsonly/bsh_curl.git
cd bsh_curl.git
# Making the script executable via './'
chmod +x cur_path.sh
```

## Running the script
```sh
# Script
./cur_path.sh https://example.com
```
