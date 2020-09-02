#!/bin/bash
source /modulecost/bargs.sh "$@"

# Global variables
_ARCHIVE_FILE_NAME=archive.tar


download_archive(){
  declare -a archive_options=(tarball zipball)
  for option in "${archive_options[@]}"; do
    _DOWNLOAD_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/${option}/${BRANCH_NAME}"
    if curl -sL "$_DOWNLOAD_URL" -o "$_ARCHIVE_FILE_NAME"; then
      echo "Downloaded archive - $_ARCHIVE_FILE_NAME"
      return
    fi

    echo "Failed to download archive"
    exit
  done
}


extract_archive(){
  if tar -xzf "$_ARCHIVE_FILE_NAME"; then
    echo "Successfully extracted $_ARCHIVE_FILE_NAME"
  else
    echo "Failed to extract archive - $_ARCHIVE_FILE_NAME"
    exit
  fi
}


get_dir_name(){
  local archive_directory_name
  archive_directory_name=$(find . -type d -maxdepth 1 -name "${GITHUB_REPOSITORY//\//-}*")

  if [[ -d "$archive_directory_name" ]]; then
    echo "$archive_directory_name/${MODULE_DIR_PATH}"
  else
    exit
  fi
}


run_infracost(){
  local tfdir_path
  tfdir_path=$(get_dir_name)
  infracost --tfdir "$tfdir_path"
}


# Main
download_archive
extract_archive
run_infracost
