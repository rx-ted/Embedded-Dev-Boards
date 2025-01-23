#!/bin/bash

if [ -z "${Embedded_Dev_Boards_PATH}" ]; then
	echo "Embedded_Dev_Boards_PATH is not set in the environment."
	current_script_dir=$(dirname "$(realpath "$0")")
	Embedded_Dev_Boards_PATH=$(dirname "$current_script_dir")
fi

if [ -z "${Embedded_Dev_Boards_PATH}" ]; then
	echo "Failed to set environment!"
	exit 1
fi

echo "The path defaults to \"$Embedded_Dev_Boards_PATH\"."
echo "Preparing to create this path and set up the environment."
export Embedded_Dev_Boards_PATH="$Embedded_Dev_Boards_PATH"
echo "Embedded_Dev_Boards_PATH has been set successfully."
