## Backup Files

#### Funcionalidades
    1 - Comprime e armazena seus backups na pasta desejada.
    2 - Armazena o último arquivo de backup, somente se este for diferente do anterior.
    3 - Armazena uma quantidade delimitada de arquivos.
    4 - Remove os backups mais antigos excedentes a quantidade delimitada.

#### Configurações
Edite isto no arquivo de configurações "backup_files.cfg".
    BACKUP_RETAIN_DAYS
    Quantidade de dias de backup que deverá manter. Ex: Use 10, para manter 10 dias de arquivos de backup.
    
    PREFIX_FILE
    Prefixo do nome do arquivo de backup. Ex: **website-**2020-05-05.tar.gz.

    END_PATH_DEST
    Nome final da pasta de destino de backup. Ex: Use o nome nq_dest, para salvar na pasta. /home/user/backups/filebackup/**nq_dest**.
    
    END_PATH_ORIG:  
    Nome final da pasta de origem do backup. Ex: Use o nome wordpress, para obter a pasta. /home/user/www/sites/**wordpress**.

    COMPLEMENT_PATH_ORIG:   
    Endereço raiz das pasta de origem. Ex: Use o nome www/sites, para salvar na pasta. /home/user/**www/sites**/.
    
    LOG:
    Nome do arquivo de log.

    TODAY:
    Formato da data que será salvo no nome do arquivo. Ex: Use "%Y-%m-%d" para website-**2020-15-05**.tar.gz.

#### Agendamento de execução
Cron é um utilitário que permite executar tarefas automaticamente em background.
Nesse exemplo o script será executado sempre às 2:30 AM:

    crontab -e 
    30 2 * * * /bin/sh backup_files.sh 
    service crond restart

#### Testes
Caso tenha interesse em realizar testes, você pode utilizar o comando abaixo:

    touch -d "$(date -d '2020-05-20' +'%Y%m%d%t')" website_2020-05-20.tar.gz
