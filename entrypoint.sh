#!/bin/bash

copy_binaries()
{
  find "$1" -type f -name "*.nds" -exec cp {} /output/ \;
  find "$1" -type f -name "*.elf" -exec cp {} /output/ \;
  find "$1" -type f -name "*.dldi" -exec cp {} /output/ \;
}

process_dir()
{
  local DIR_MULTIPLE=0
  # Iterate over all directories inside $1
  for dir in $1/*/; do
      # Check if it's a directory
      if [ -d "$dir" ]; then
          echo "Processing directory: $dir"
          {
            cd "$dir"
            make clean
            make
          }
          [ $? -eq 0 ] && COMPILED=1 && DIR_MULTIPLE=1
          # Find and copy all binary files from this directory to /output
          copy_binaries "${dir}"
      fi
  done

  echo dir is ${DIR_MULTIPLE}
  if [ ${DIR_MULTIPLE} -eq 0 ]; then
    {
      cd "$1"
      make clean
      make
      [ $? -eq 0 ] && COMPILED=1
    }
    copy_binaries "$1"
  fi
}


COMPILED=0

process_dir /input
process_dir /workspace

if [ ${COMPILED} -eq 1 ]; then
    echo "All binary files (.nds, .elf and .dldi) copied to /output."
else
    echo "No directories or content present in /input or /workspace to compile. Entering interactive mode"
    /bin/bash
fi