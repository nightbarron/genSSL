#!/bin/bash
# author: Night Barron
# Date: 14/06/2021

createSSL() {
    echo
    echo "Creating Request SSL for: "
    read -p "Enter Domain: " domainName
    read -p "Enter Organization: " organName
    read -p "Enter Province: " provinceName
    read -p "Enter location to save ${domainName}.csr, ${domainName}.key (ENTER FOR CURRENT): " location

    fileName=${domainName/"*"/"_"}

    if [ ${#location} -eq 0 ]
    then
        location=$(pwd)
    else
        { 
            mkdir -p $location
        } || {
            echo "Cannot create directory ${location}!!!"
            exit 1
        }
    fi

    echo "Save location: ${location}"

    {
        openssl req -new -newkey rsa:2048 -nodes -out "${location}/${fileName}.csr" -keyout "${location}/${fileName}.key" \
        -subj "/C=VN/ST=${provinceName}/L=${provinceName}/O=${organName}/OU=IT Department/CN=${domainName}/emailAddress=webmaster@${domainName}"
    } || {
        echo "Cannot create SSL at \"${location}\"!!!"
        exit 1
    }
    echo
    echo "Completed!"
}

checkSSL() {
    echo 
    echo "Checking SSL for: "
    read -p "Enter Domain (without protocol): " domainName
    # openssl s_client -connect ${domainName}:443 # this using without protocol to check
    curl -vI https://${domainName} &> /tmp/ssl.tmp
    echo "WARNING: If nothing below, it mean no SSL certificates!"
    echo "Starting get SSL Cer..."
    cat /tmp/ssl.tmp | grep -Pzo '\* Server certificate:((.|\n)*(\.\n))'
    rm -rf /tmp/ssl.tmp
}

main() {
    echo "Welcome to SSL Tool"
    echo "Author: Night Barron"
    echo "Date: 16/06/2021"
    echo
    echo "1. Create SSL Request"
    echo "2. Check SSL for domain"
    echo "other. Exit"
    read -p "Enter your choice: " choice
    if [ ${choice} -eq 1 ]
    then
        createSSL
    elif [ ${choice} -eq 2 ]
    then
        checkSSL
    fi
    echo "Exit!"
    exit 0
}

main