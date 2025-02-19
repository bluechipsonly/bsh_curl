#!/bin/bash

LOG_FILE="curl_requests.log"

# Function to log requests
log_request() {
    local url="$1"
    local status_code="$2"
    local response_time="$3"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | URL: $url | Status: $status_code | Time: ${response_time}ms" >> "$LOG_FILE"
}

# Function to run curl with enhanced features
enhanced_curl() {
    local url="$1"
    local retries=3
    local delay=2

    echo "Requesting: $url"
    
    for ((i=1; i<=retries; i++)); do
        start_time=$(date +%s%3N)
        response=$(curl -s -w "%{http_code} %{time_total}" -o response_body.txt "$url")
        status_code=$(awk '{print $1}' <<< "$response")
        response_time=$(awk '{print $2}' <<< "$response")

        # Log the request
        log_request "$url" "$status_code" "$response_time"

        # Show output
        if [[ "$status_code" =~ ^2 ]]; then
            echo -e "\e[32mSuccess ($status_code) - Response Time: ${response_time}s\e[0m"
            cat response_body.txt
            return 0
        elif [[ "$status_code" =~ ^3 ]]; then
            echo -e "\e[34mRedirect ($status_code) - Response Time: ${response_time}s\e[0m"
            cat response_body.txt
            return 0
        elif [[ "$status_code" =~ ^4 ]]; then
            echo -e "\e[33mClient Error ($status_code) - Retrying ($i/$retries)...\e[0m"
        elif [[ "$status_code" =~ ^5 ]]; then
            echo -e "\e[31mServer Error ($status_code) - Retrying ($i/$retries)...\e[0m"
        else
            echo -e "\e[35mUnknown Response ($status_code) - Retrying ($i/$retries)...\e[0m"
        fi

        sleep "$delay"
    done

    echo -e "\e[31mRequest failed after $retries attempts.\e[0m"
    return 1
}

# Check for input URL
if [[ -z "$1" ]]; then
    echo "Usage: ./curl_helper.sh <URL>"
    exit 1
fi

# Run enhanced curl
enhanced_curl "$1"
