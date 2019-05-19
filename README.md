# rclone-scheduled-backups

A few files to facilitate scheduled backups using rclone

### What It Does

- Runs `rclone sync` to any given remote
- If backups are enabled, one will be attempted every 10 minutes
- If a backup is running, another will not be scheduled until it finishes
- You can include/exclude any file/directory patterns in the sync

## Setup

##### STEP 1

rclone-scheduled-backups assumes that you have rclone installed on your machine with a valid remote configured.

##### STEP 2

Create a `~./backup_config` file in the following format (also see `.backup_config_example`):

```
# DEST_FILEPATH=BACKUPS/cpu
# RCLONE_REMOTE=gdrive

# exclude
- node_modules/**
- .DS_Store

# include
+ projects/**
+ media/**
- media/watch/**
+ scripts/**
+ work/**
+ portfolio/**

# exclude everything else
- *
```

- `DEST_FILEPATH` refers to destination `path` argument in the rclone sync program. See (https://rclone.org/commands/rclone_sync/)
- `RCLONE_REMOTE` refers to the name of the rclone remote you would like to sync to.

  _These lines must be commented out and there cannot be a space after the `=` sign._

- The rest of the file should follow the format for rclone's `--filter-from` file argument. See (https://rclone.org/filtering/#filter-from-read-filtering-patterns-from-a-file)

##### STEP 3

Place `backup.sh` in `$HOME/scripts/backup/backup.sh`

##### STEP 4

Add the commands from `commands.sh` to your bash profile.

- `enable_backups` will enable backups
- `disable_backups` will disable backups
- `backups_enabled?` returns whether backups are enabled or not

##### STEP 5

Move `com.backup.cron.plist` to `~/Library/LaunchAgents/com.backup.cron.plist` and run `launchctl load ~/Library/LaunchAgents/com.backup.cron.plist`

##### ALL DONE!

You should be up and running with scheduled rclone syncs. To uninstall the daemon, run `launchctl unload ~/Library/LaunchAgents/com.backup.cron.plist`. The program will log to `~/backup_log` for debugging.
