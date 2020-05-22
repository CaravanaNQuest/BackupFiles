## Backup Files

#### Functions
    1 - Compress and stores backup files in a specific folder
    2 - Stores last backup file. Only if is different from last one.
    3 - Stores a delimited quantity of files.
    4 - Remove the oldest backup files that exceed the delimited quantity.

#### Configuration
Make these edtions in the file config "backup_files.cfg".
    BACKUP_RETAIN_DAYS
    Quantity of days that backup file needs to keep, e.g., uses 10 to keep 10 days of backup files.
    
    PREFIX_FILE
    Backup file name prefix, e.g., **website-**2020-05-05.tar.gz.

    END_PATH_DEST
    Final name of the backup destination folder, e.g., uses nq_dest name to save into the folder /home/user/backups/filebackup/**nq_dest**.
    
    END_PATH_ORIG:  
    Final name of the backup origin folder, e.g., uses wordpress name get the folder /home/user/www/sites/**wordpress**.

    COMPLEMENT_PATH_ORIG:  
    Root address of the origin folder, e.g., uses the name www/sites to save into the folder /home/user/**www/sites**/.
    
    LOG:
    Name of logs file.

    TODAY:
    Date format that will be saved in the name file name, e.g., Use "%Y-%m-%d" to website-**2020-15-05**.tar.gz.

#### Task schedule
Cron is an utility that allows you to run tasks automatically in the background.
In this example the script will always be executed at 2.30 a.m.:

    crontab -e 
    30 2 * * * /bin/sh backup_files.sh 
    service crond restart

#### Tests
If you are interested in performing some tests you can use the command bellow:

    touch -d "$(date -d '2020-05-20' +'%Y%m%d%t')" website_2020-05-20.tar.gz
