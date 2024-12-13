#!/bin/bash

endpoints=(
  "https://mlservice.at04.devops.jala.university/recognition"
  "https://mlservice.at04.devops.jala.university/face_recognition"
)

for url in "${endpoints[@]}"; do
  echo "Testing $url"
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $url)
  if [ "$http_code" -ne 200 ]; then
    echo "Test failed for $url with HTTP code $http_code"
    exit 1
  else
    echo "Test passed for $url"
  fi
done