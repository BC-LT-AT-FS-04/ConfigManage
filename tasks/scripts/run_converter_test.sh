#!/bin/bash

# Base URL for the ConverterService
BASE_URL="https://dev-converter.devops.jala.university"

# Endpoints
VIDEO_TO_IMAGES_ENDPOINT="/api/video-to-images"
# VIDEO_TO_VIDEO_ENDPOINT="/api/video-to-video"

# Test files
TEST_VIDEO_FILE="./tests/resources/test_video.mp4"

# Function to test video-to-images endpoint
test_video_to_images() {
    echo "Testing Video to Images endpoint..."
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -F "file=@${TEST_VIDEO_FILE}" \
        "$BASE_URL$VIDEO_TO_IMAGES_ENDPOINT")

    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        echo "✅ Video to Images endpoint is working correctly (HTTP $HTTP_RESPONSE)."
    else
        echo "❌ Video to Images endpoint failed (HTTP $HTTP_RESPONSE)."
    fi
}

# Function to test video-to-video endpoint
# test_video_to_video() {
#     echo "Testing Video to Video endpoint..."
#     HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
#         -X POST \
#         -F "file=@${TEST_VIDEO_FILE}" \
#         -F "format=mp4" \
#         "$BASE_URL$VIDEO_TO_VIDEO_ENDPOINT")

#     if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
#         echo "✅ Video to Video endpoint is working correctly (HTTP $HTTP_RESPONSE)."
#     else
#         echo "❌ Video to Video endpoint failed (HTTP $HTTP_RESPONSE)."
#     fi
# }

# Main script execution
echo "Running ConverterService tests..."
test_video_to_images
# test_video_to_video
echo "All tests completed."
