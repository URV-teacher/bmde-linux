#!/bin/bash

DIR_PRESENT=0

# Iterate over all directories inside /input
for dir in /input/*/; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        DIR_PRESENT=1
        echo "Processing directory: $dir"
        {
          cd "$dir"
          make clean
          make
        }
        # Find and copy all .nds files from this directory to /output
        find "$dir" -type f -name "*.nds" -exec cp {} /output/ \;
    fi
done

if [ $DIR_PRESENT == 1 ]; then
    echo "All .nds files copied to /output."
else
    echo "No directories present in /input to compile. Entering interactive mode"
    /bin/bash
fi