#!/usr/bin/env bash

#####################################################
##                                                 ##
##   Files Backup                                  ##
##                                                 ##
##   Authors: Guilherme Araujo aka Gartisk         ##
##            Sandro Macena aka SMacena            ##
##                                                 ##
##   Version: 0.3                                  ##
##   Last Update: May 17, 2020                     ##
##                                                 ##
#####################################################

# Em caso de erro use dos2unix para converter arquivo
export PATH=/bin:/usr/bin:/usr/local/bin

# set -o errexit                                                            # Used to exit upon error, avoiding cascading errors
set -o noclobber                                                            # Avoid overlay files (echo "hi" > foo)
set -o errtrace                                                             # Make sure any error trap is inherited
set -o nounset                                                              # Disallow expansion of unset variables
set -o pipefail                                                             # Use last non-zero exit code in a pipeline

# Enable xtrace if the DEBUG environment variable is set
if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace                                                           ## Trace the execution of the script (debug)
fi

# Internal Field Separator
SAVE_IFS=$IFS
IFS=$(echo -en '\n\b')

# On my tests shared hosting the JailBreak block the command ${0%/*}, then is not possible to use "${0%/*}backup_files.cfg".
SRC=${0}
BASE=${SRC##*/}
DIR=${SRC%$BASE}

source "${DIR}backup_files.cfg"

function ctrl_c() {
    log $(printf 'Script interrompido pelo usuário. Até Logo!')
}

function dt() {
    printf $(date +'%Y-%m-%d %T')
}

function log() {
    printf '%s: %s\n' $(dt) $1 2>&1 | tee -a ${LOG}
}

function delete_old_files() {
    local file_name_list=($(ls -t "${DEST_PATH}"))
    local exceeded_days=$((${#file_name_list[*]} - ${BACKUP_RETAIN_DAYS}))

    if [[ ${exceeded_days} -le 0 ]]; then
        return
    fi

    local exceeded_file_list=($(ls -t "${DEST_PATH}" | tail -n "${exceeded_days}"))

    for file_name in ${exceeded_file_list[*]}; do
        local remove_result=($(rm "${DEST_PATH}/${file_name}"))
        if [[ $? -ne 0 ]]; then
            log $(sprintf 'Não foi possível remover '"${DEST_PATH}/${file_name}")
            log ${remove_result}
            continue
        fi
        log $(printf "${DEST_PATH}/${file_name}"' foi removido, pois a pasta de backup excede a capacidade '"${BACKUP_RETAIN_DAYS}"' arquivos.')
    done
}

function create_tar() {
    if [[ -f "${NEW_BACKUP_FILE}" ]]; then
        log $(printf 'O backup dos arquivos já foi realizado para este dia.')
        return 1
    fi

    local tar_result=$(tar --directory "${ORIGIN_BACKUP}" --create --bzip --preserve-permissions --file "${NEW_BACKUP_FILE}" "${END_PATH_ORIG}")
    if [[ $? -ne 0 ]]; then
        log tar_result
        return 1
    fi

    log $(printf "${NEW_BACKUP_FILE}"' foi criado com sucesso.')
    return 0
}

function are_equals_the_two_latest_files() {
    local latest_files=($(ls -t "${DEST_PATH}" | head -n 2))

    # Se não possui 2 itens pelo menos, então retorna 0
    if [[ ${#latest_files[*]} -lt 2 ]]; then
        echo 0
        return
    fi

    local sum_first_file=($(md5sum "${DEST_PATH}/${latest_files[0]}" | awk '{print $1}'))
    local sum_second_file=($(md5sum "${DEST_PATH}/${latest_files[1]}" | awk '{print $1}'))

    # Se md5 dos arquivos sao diferentes retorna 0
    if [[ ${sum_first_file} != ${sum_second_file} ]]; then
        echo 0
        return
    fi

    # Se md5 dos arquivos são iguais retorna 1
    echo 1
    return
}

function main() {
    trap ctrl_c INT

    log $(printf 'Files Backup Iniciado.')
    
    create_tar

    if [[ $? -eq 0 ]]; then

        local are_equals=$(are_equals_the_two_latest_files)
        # Se novo backup é igual ao anterior, então apaga o novo arquivo de backup.
        if [[ ${are_equals} -eq 1 ]]; then
            (rm "${NEW_BACKUP_FILE}")
            log $(printf '%s %s' "${NEW_BACKUP_FILE}" 'foi removido pois já o arquivo é identico ao backup anterior.')
        fi

    fi 
    
    delete_old_files

    log $(printf '%s' 'Files Backup Finalizado com Sucesso.')
    exit 0
}

main

IFS=$SAVE_IFS
### End of script ####
