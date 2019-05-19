DATA_FILEPATH=~/.backup

disable_backups() {
  echo "false" > $DATA_FILEPATH
  echo "backups disabled"
}

enable_backups() {
  echo "true" > $DATA_FILEPATH
  echo "backups enabled"
}

backups_enabled?() {
  echo `cat $DATA_FILEPATH`
}
