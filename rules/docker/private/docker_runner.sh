#!/bin/bash

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <executable> <image-name> <file-path-in-container> <output-file> [additional-args...]"
    exit 1
fi

# Extract the first two arguments
docker_executable=$1
dockerfile=$2
image_name=$3
path_in_container=$4
tar_file=$5
output_file=$6

# Shift the arguments so that $@ contains only the additional arguments
shift 6

# Execute the given executable with the remaining arguments
rm -f "$output_file"

"$docker_executable" build "-t" "$image_name" "$dockerfile"

# Check if the execution was successful
if [ $? -ne 0 ]; then
    rm -f "$output_file"
    exit 252
fi

id=$("$docker_executable" create "$image_name")

echo "docker image:" $id

# Check if the execution was successful
if [ $? -ne 0 ]; then
    rm -f "$output_file"
    exit 253
fi

"$docker_executable" cp "$id":"$path_in_container" - > "$tar_file"

# Check if the execution was successful
if [ $? -ne 0 ]; then
    rm -f "$output_file"
    exit 254
fi

tar xv -C "$dockerfile" -f "$tar_file"

# Check if the execution was successful
if [ $? -eq 0 ]; then
   # popd >> /dev/null
    echo Success
    exit 0
fi

exit 255
