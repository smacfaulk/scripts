#!/bin/bash

# Function to recursively rename files and directories and move them to a new location
move_and_rename() {
    local SRC_DIR=$1
    local DEST_DIR=$2

    # Create the destination directory structure
    find "$SRC_DIR" -type d | while read -r dir; do
        local newdir="${dir/$SRC_DIR/$DEST_DIR}"
        newdir=$(echo "$newdir" | tr '[:upper:]' '[:lower:]')
        mkdir -p "$newdir"
    done

    # Move and rename files
    find "$SRC_DIR" -type f | while read -r file; do
        local dir=$(dirname "$file")
        local base=$(basename "$file")
        local newdir="${dir/$SRC_DIR/$DEST_DIR}"
        newdir=$(echo "$newdir" | tr '[:upper:]' '[:lower:]')
        local newbase=$(echo "$base" | tr '[:upper:]' '[:lower:]')
        mv -i "$file" "$newdir/$newbase"
    done
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Source and destination directories
SRC_DIR="$1"
DEST_DIR="$2"

# Check if the provided source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory $SRC_DIR does not exist."
    exit 1
fi

# Start the moving and renaming process
move_and_rename "$SRC_DIR" "$DEST_DIR"

echo "All files and directories from $SRC_DIR have been moved to $DEST_DIR and renamed to lowercase."

