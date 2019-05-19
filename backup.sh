#!/usr/bin/env sh
exec &> ~/.backup_log

DATA_FILEPATH=~/.backup
CONFIG_FILEPATH=~/.backup_config
SHOULD_BACKUP=false

dest_filepath_reg="DEST_FILEPATH=(.*)"
rclone_remote_reg="RCLONE_REMOTE=(.*)"
DEST_FILEPATH=""
RCLONE_REMOTE=""

while read -r line
do
  if [[ $line =~ $dest_filepath_reg ]]; then
    DEST_FILEPATH=${BASH_REMATCH[1]};
  fi
  if [[ $line =~ $rclone_remote_reg ]]; then
    RCLONE_REMOTE=${BASH_REMATCH[1]};
  fi
done < "$CONFIG_FILEPATH"

if [[ $DEST_FILEPATH == "" ]]; then
  echo "$(date) DEST_FILEPATH not defined"
  exit 1
fi

if [[ $RCLONE_REMOTE == "" ]]; then
  echo "$(date) RCLONE_REMOTE not defined"
  exit 1
fi

if [[ -f "$DATA_FILEPATH" ]]; then
    SHOULD_BACKUP="`cat $DATA_FILEPATH`"
else
    echo "false" > $DATA_FILEPATH
fi

if [[ $SHOULD_BACKUP == running ]]; then
  echo "$(date) currently syncing"
  exit 0
fi

if [[ $SHOULD_BACKUP == true ]]; then
  echo "$(date) beginning backup"
  echo "running" > $DATA_FILEPATH

  rclone sync ~ $RCLONE_REMOTE:$DEST_FILEPATH --filter-from $CONFIG_FILEPATH --progress

  UPDATED_SHOULD_BACKUP="`cat $DATA_FILEPATH`"
  if [[ $UPDATED_SHOULD_BACKUP == "running" ]]; then
    echo "true" > $DATA_FILEPATH
  fi
  exit 0
else
  echo "$(date) skipping backup"
  exit 0
fi
