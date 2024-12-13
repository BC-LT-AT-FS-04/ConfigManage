#!/bin/bash

# Script for User Acceptance Testing of MLService

#Image configuration variables
drive_file_id="1TjCRJQr3_102Y2OmvrDiljOATqDc68Hd"
temp_file=$(mktemp)

# Download 
echo "Downloadign file from Google Drive..."
curl -L "https://drive.google.com/uc?export=download&id=$drive_file_id" -o "$temp_file"
if [ $? -ne 0 ]; then
    echo "Download error"
    exit 1
fi

# List of endpoints
endpoints=(
    "http://mlservice.at04.devops.jala.university/api/recognition"
    "http://mlservice.at04.devops.jala.university/api/face_recognition"
)

# Payload for the recognition endpoint
payload_recognition='{
    "zip_url": "http://10.27.5.151:9090//api/download-frames/ac87079166408a172599b7acdd151fa3708a684f15e9592a50a835b50743313a.zip",
    "model_type": "object",
    "confidence_threshold": 0.5,
    "word": "dog"
}'

# Data for the face_recognition endpoint
zip_url="http://10.27.5.151:9090//api/download-frames/556f030a81257cbfeacf800c2a1443a1dddea8dcae5ce58eb15dde6d83027663.zip"
model_type="face"
confidence_threshold=0.1
word="woman"

# Variable to track overall status
overall_status=0

# Iterate over endpoints and test them
for endpoint in "${endpoints[@]}"; do
    echo "Testing: $endpoint (POST)"

    # Prepare the common curl command structure
    if [[ "$endpoint" == *"/recognition" ]]; then
        # Send JSON payload for /recognition endpoint
        response_code=$(curl -s -o /dev/null -w "%{http_code}" \
            -X POST "$endpoint" \
            -H "Content-Type: application/json" \
            -d "$payload_recognition")
    else
        # Send form-data for /face_recognition endpoint
        response_code=$(curl -s -o /dev/null -w "%{http_code}" \
            -X POST "$endpoint" \
            -F "zip_url=$zip_url" \
            -F "model_type=$model_type" \
            -F "confidence_threshold=$confidence_threshold" \
            -F "word=$word" \
            -F "image_file_reference=@$temp_file")
    fi

    # Check the response code
    if [ "$response_code" -eq 200 ]; then
        echo "$endpoint responded with HTTP 200."
    else
        echo "$endpoint failed with HTTP code $response_code."
        overall_status=1
    fi
done

# Exit with the overall status
if [ "$overall_status" -eq 0 ]; then
    echo "All acceptance tests passed successfully."
else
    echo "Some acceptance tests failed."
fi

exit $overall_status

