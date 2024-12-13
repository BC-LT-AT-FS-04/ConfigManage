#!/bin/bash

# Base URL for the ConverterService
BASE_URL="http://dev-converter.at04.devops.jala.university"

# Endpoints
VIDEO_TO_IMAGES_ENDPOINT="/api/video-to-images"
VIDEO_TO_VIDEO_ENDPOINT="/api/video-to-video"
IMAGE_CONFIGURATION_ENDPOINT="/api/image-configuration"
AUDIO_CONVERSION_ENDPOINT="/api/convert-audio"

# Google Drive File IDs
TEST_VIDEO_FILE_ID="1Ge9aEgZCNr2aEujsLjjtURX4k_W5YQxi"
TEST_IMAGE_FILE_ID="1KbF4CXg8h2p6k9fHW8Y-ip188dA73gfK"
TEST_AUDIO_FILE_ID="1DQDX5L0iy_Izw0affAYwGk1GvbrqVy2R"

# Temporary files to store downloaded content
TEMP_VIDEO_FILE=$(mktemp --suffix=".mp4")
TEMP_IMAGE_FILE=$(mktemp --suffix=".jpg")
TEMP_AUDIO_FILE=$(mktemp --suffix=".mp3")

# Function to download files from Google Drive
download_from_drive() {
    local file_id=$1
    local output_file=$2
    echo "Downloading file from Google Drive with ID: $file_id..."
    curl -L "https://drive.google.com/uc?export=download&id=$file_id" -o "$output_file"
    if [ $? -ne 0 ]; then
        echo "Download error for $file_id"
        exit 1
    fi
}

# Download test files from Google Drive
download_from_drive "$TEST_VIDEO_FILE_ID" "$TEMP_VIDEO_FILE"
download_from_drive "$TEST_IMAGE_FILE_ID" "$TEMP_IMAGE_FILE"
download_from_drive "$TEST_AUDIO_FILE_ID" "$TEMP_AUDIO_FILE"

# Function to test video-to-images endpoint
test_video_to_images() {
    echo "Testing Video to Images endpoint..."
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -F "file=@${TEMP_VIDEO_FILE}" \
        "$BASE_URL$VIDEO_TO_IMAGES_ENDPOINT")

    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        echo "Video to Images endpoint is working correctly (HTTP $HTTP_RESPONSE)."
    else
        echo "Video to Images endpoint failed (HTTP $HTTP_RESPONSE)."
    fi
}

# Function to test video-to-video endpoint
test_video_to_video() {
    echo "Testing Video to Video endpoint..."
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -F "file=@${TEMP_VIDEO_FILE}" \
        -F "format=mp4" \
        -F "fps=30" \
        -F "video_codec=libx264" \
        -F "audio_codec=aac" \
        -F "audio_channels=2" \
        "$BASE_URL$VIDEO_TO_VIDEO_ENDPOINT")

    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        echo "Video to Video endpoint is working correctly (HTTP $HTTP_RESPONSE)."
    else
        echo "Video to Video endpoint failed (HTTP $HTTP_RESPONSE)."
    fi
}

# Function to test image-configuration endpoint
test_image_configuration() {
    echo "Testing Image Configuration endpoint..."

    # Define test parameters
    RESIZE_WIDTH="200"
    RESIZE_HEIGHT="200"
    RESIZE_TYPE="THUMBNAIL"
    OUTPUT_FORMAT="png"
    ROTATE_ANGLE="90"
    FILTERS=("GRAYSCALE" "DETAIL")

    # Prepare filters as repeated form-data fields
    FILTERS_PARAMS=""
    for FILTER in "${FILTERS[@]}"; do
        FILTERS_PARAMS+=" -F filter=${FILTER}"
    done

    # Perform the POST request
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -F "image=@${TEMP_IMAGE_FILE}" \
        -F "resize_width=${RESIZE_WIDTH}" \
        -F "resize_height=${RESIZE_HEIGHT}" \
        -F "resize_type=${RESIZE_TYPE}" \
        -F "output_format=${OUTPUT_FORMAT}" \
        -F "rotate=${ROTATE_ANGLE}" \
        $FILTERS_PARAMS \
        "$BASE_URL$IMAGE_CONFIGURATION_ENDPOINT")

    # Check the HTTP response
    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        echo "Image Configuration endpoint is working correctly (HTTP $HTTP_RESPONSE)."
    else
        echo "Image Configuration endpoint failed (HTTP $HTTP_RESPONSE)."
    fi
}

# Function to test audio-to-audio endpoint
test_audio_conversion() {
    echo "Testing Audio Conversion endpoint..."

    # Define test parameters
    OUTPUT_FORMAT="mp3"
    BIT_RATE="192K"
    SAMPLE_RATE="44100"
    VOLUME="1.5"
    LANGUAGE_CHANNEL="1"
    SPEED="2.0"

    # Perform the POST request
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -F "audio=@${TEMP_AUDIO_FILE}" \
        -F "output_format=${OUTPUT_FORMAT}" \
        -F "bit_rate=${BIT_RATE}" \
        -F "sample_rate=${SAMPLE_RATE}" \
        -F "volume=${VOLUME}" \
        -F "language_channel=${LANGUAGE_CHANNEL}" \
        -F "speed=${SPEED}" \
        "$BASE_URL$AUDIO_CONVERSION_ENDPOINT")

    # Check the HTTP response
    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        echo "Audio Conversion endpoint is working correctly (HTTP $HTTP_RESPONSE)."
    else
        echo "Audio Conversion endpoint failed (HTTP $HTTP_RESPONSE)."
    fi
}

# Main script execution
echo "Running ConverterService tests..."
test_video_to_images
test_video_to_video
test_image_configuration
test_audio_conversion
echo "All tests completed."
