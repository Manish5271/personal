#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "This script must be run as root ... \e[1;31m[ERROR] \e[0m\n"
    exit 1
else


    backupdate14=$(date -d "-14 days" +"%d%m%Y")
    backupdate13=$(date -d "-13 days" +"%d%m%Y")
    backupdate12=$(date -d "-12 days" +"%d%m%Y")
    backupdate11=$(date -d "-11 days" +"%d%m%Y")
    backupdate10=$(date -d "-10 days" +"%d%m%Y")
    backupdate9=$(date -d "-9 days" +"%d%m%Y")
    backupdate8=$(date -d "-8 days" +"%d%m%Y")
    backupdate7=$(date -d "-7 days" +"%d%m%Y")
    backupdate6=$(date -d "-6 days" +"%d%m%Y")
    backupdate5=$(date -d "-5 days" +"%d%m%Y")
    backupdate4=$(date -d "-4 days" +"%d%m%Y")
    backupdate3=$(date -d "-3 days" +"%d%m%Y")
    backupdate2=$(date -d "-2 days" +"%d%m%Y")
    backupdate1=$(date -d "-1 days" +"%d%m%Y")


    day14="$backupdate14.tar.gz"
    day13="$backupdate13.tar.gz"
    day12="$backupdate12.tar.gz"
    day11="$backupdate11.tar.gz"
    day10="$backupdate10.tar.gz"
    day9="$backupdate9.tar.gz"
    day8="$backupdate8.tar.gz"
    day7="$backupdate7.tar.gz"
    day6="$backupdate6.tar.gz"
    day5="$backupdate5.tar.gz"
    day4="$backupdate4.tar.gz"
    day3="$backupdate3.tar.gz"
    day2="$backupdate2.tar.gz"
    day1="$backupdate1.tar.gz"

#below function is used to delete the file from teh destination path if its alredy available. it will delet the old file from last week at the time of script execution 
    function files_delete () {
        for days in $day8 $day9 $day10 $day11 $day12 $day13 $day14; do
            #echo -e "$day8 $day9 $day10 $day11 $day12 $day13 $day14"
            if [[ -e "$destination/$days" ]]; then
                echo -e "$days is presnt in the $destination"
                echo -e "$days is removing from $destination "
                rm $destination/$days
            else    
                echo -e "$days is alredy removed from $destination"
            fi
        done
    }
#below function is used to copy the file from source to destintion ie dnif config backup to mountpoint 
    function copy_checksum () {
        for day in $day7 $day6 $day5 $day4 $day3 $day2 $day1; do
            destination_file="$destination/$day"

            if [[ -e "$destination_file" ]]; then
                echo "$day is already present in $destination"
            else
                if cp "$source_dir/$day" "$destination"; then
                    echo "Copied $day from $source_dir to $destination"
                else
                    echo "Failed to copy $day from $source_dir to $destination"
                    continue
                fi
            fi

            if [[ -e "$destination_file" ]]; then
                original_checksum=$(md5sum "$source_dir/$day" | awk '{ print $1 }')
                copied_checksum=$(md5sum "$destination_file" | awk '{ print $1 }')

                if [[ "$original_checksum" == "$copied_checksum" ]]; then
                    echo "MD5 checksums matched for $day."
                else
                    echo "MD5 checksums do not match for $day. The files may be corrupted."
                fi
            else
                echo "File $day is not present in $destination"
            fi
        done
    }

    #------------------------------------------------------------------------------
    function files_delete_co() {
        destination_co="/var/tmp/bh/co"
        destination_mdn="/var/tmp/bh/dn"
        
        for days in $day8 $day9 $day10 $day11 $day12 $day13 $day14; do
            if [[ -e "$destination_co/$days" ]]; then
                echo -e "$days is present in $destination_co"
                echo -e "Removing $days from $destination_co"
                rm "$destination_co/$days"
            else    
                echo -e "$days is already removed from $destination_co"
            fi
            
            if [[ -e "$destination_mdn/$days" ]]; then
                echo -e "$days is present in $destination_mdn"
                echo -e "Removing $days from $destination_mdn"
                rm "$destination_mdn/$days"
            else    
                echo -e "$days is already removed from $destination_mdn"
            fi
        done
    }

    function copy_checksum_co() {        
        for day in $day7 $day6 $day5 $day4 $day3 $day2 $day1; do
            if [[ -e "$destination_co/$day" ]]; then
                echo "$day is already present in $destination_co"
            else
                if cp "$source_dir_co/$day" "$destination_co"; then
                    echo "Copied $day from $source_dir_co to $destination_co"
                else
                    echo "Failed to copy $day from $source_dir_co to $destination_co"
                    continue
                fi
            fi
            
            if [[ -e "$destination_mdn/$day" ]]; then
                echo "$day is already present in $destination_mdn"
            else
                if cp "$source_dir_mdn/$day" "$destination_mdn"; then
                    echo "Copied $day from $source_dir_mdn to $destination_mdn"
                else
                    echo "Failed to copy $day from $source_dir_mdn to $destination_mdn"
                    continue
                fi
            fi

            if [[ -e "$destination_co/$day" ]]; then
                original_checksum=$(md5sum "$source_dir_co/$day" | awk '{ print $1 }')
                copied_checksum=$(md5sum "$destination_co/$day" | awk '{ print $1 }')

                if [[ "$original_checksum" == "$copied_checksum" ]]; then
                    echo "MD5 checksums matched for $day in $destination_co."
                else
                    echo "MD5 checksums do not match for $day in $destination_co. The file may be corrupted."
                fi
            else
                echo "File $day is not present in $destination_co"
            fi

            if [[ -e "$destination_mdn/$day" ]]; then
                original_checksum=$(md5sum "$source_dir_mdn/$day" | awk '{ print $1 }')
                copied_checksum=$(md5sum "$destination_mdn/$day" | awk '{ print $1 }')

                if [[ "$original_checksum" == "$copied_checksum" ]]; then
                    echo "MD5 checksums matched for $day in $destination_mdn."
                else
                    echo "MD5 checksums do not match for $day in $destination_mdn. The file may be corrupted."
                fi
            else
                echo "File $day is not present in $destination_mdn."
            fi
        done

    }

    #------------------------------------------------------------------------------

   #-------------------belwo loops are for the adapter------------------------------
   #-------incase if need to add more adapter just copy the loop and add the new ad ip in server ip---------------
   #-----------chnage the destination path as per requriment-----------------------------
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w adapter-v9) == "adapter-v9" ]]; then
        server_ip=$(grep -oP 'localIPv4Address: \K[\d.]+' /DNIF/AD/csltuconfig/system.yml)
        
        if [[ "$server_ip" == "10.202.0.84" ]]; then
            destination="<dest path>"
            source_dir="/DNIF/backup/ad"
            copy_checksum

            files_delete
        fi
        
        if [[ "$server_ip" == "10.202.0.85" ]]; then
            destination="<dest path>"
            source_dir="/DNIF/backup/ad"
            copy_checksum

            files_delete
        fi
    fi

    #-------------------------------below loops are for the datanodes--------------------------
    #------------------------------incase the need to add DN follows the same as done for AD---------
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w datanode-v9) == "datanode-v9" ]]; then
        server_ip=$(grep -oP 'localIPv4Address: \K[\d.]+' /DNIF/DL/csltuconfig/system.yml)
        
        if [[ "$server_ip" == "10.202.0.88" ]]; then
            destination="<dest path>"
            source_dir="/DNIF/backup/"
            copy_checksum

            files_delete

        fi

        if [[ "$server_ip" == "10.202.0.89" ]]; then
            destination="<dest path>"
            source_dir="/DNIF/backup/"
            copy_checksum

            files_delete

        fi
    fi

    #-----------------------below loop is for the CORE server-------------------
    if [[ $(docker ps -a --format '{{.Names}}' | grep -w core-v9) == "core-v9" ]]; then
        server_ip=$(grep -oP 'localIPv4Address: \K[\d.]+' /DNIF/CO/csltuconfig/system.yml)
        if [[ "$server_ip" == "10.202.0.90" ]]; then
            destination_co="<dest path>"
            source_dir_co="/DNIF/backup/core"
            destination_mdn="<dest path>"
            source_dir_mdn="/DNIF/backup/dn"
            copy_checksum_co
            
            files_delete_co

        fi
    fi
    
    #----------------------below loop is for the PICOs----------------------

    if [[ $(docker ps -a --format '{{.Names}}' | grep -w pico-v9) == "pico-v9" ]]; then
        server_ip=$(grep -oP 'localIPv4Address: \K[\d.]+' /DNIF/PICO/csltuconfig/system.yml)
        
        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<dest path>"
            source_dir="/DNIF/backup/pc"
            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi

        if [[ "$server_ip" == "<IP>" ]]; then
            destination="<destination>"
            source_dir="/DNIF/backup/pc"

            copy_checksum

            files_delete
        fi
    fi

fi
