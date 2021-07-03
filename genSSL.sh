#!/bin/bash
# author: Night Barron
# Date: 14/06/2021

createSSL() {
    domainName=$1
    echo "Creating Request SSL for $domainName: "
    # read -p "Enter Domain: " domainName
    read -p "Enter Company: " organName
    read -p "Enter City: " provinceName
    read -p "Enter Email: " emailAddress
    read -p "Enter location to save ${domainName}.csr, ${domainName}.key (ENTER FOR CURRENT): " location

    fileName=${domainName/"*"/"_"}

    if [ ${#location} -eq 0 ]
    then
        location=$(pwd)
    fi

    location=$location"/${fileName}"

    { 
        mkdir -p $location
    } || {
        echo "Cannot create directory ${location}!!!"
        exit 1
    }

    echo "Save location: ${location}"

    {
        openssl req -new -newkey rsa:2048 -nodes -out "${location}/${fileName}.csr" -keyout "${location}/${fileName}.key" \
        -subj "/C=VN/ST=${provinceName}/L=${provinceName}/O=${organName}/OU=IT Department/CN=${domainName}/emailAddress=${emailAddress}"
    } || {
        echo "Cannot create SSL at \"${location}\"!!!"
        exit 1
    }
    echo
    echo "Completed!"
}

checkSSL() {
    domainName=$1
    echo "Checking SSL for $domainName..."
    # read -p "Enter Domain (without protocol): " domainName
    # openssl s_client -connect ${domainName}:443 # this using without protocol to check
    curl -vI https://${domainName} &> /tmp/ssl.tmp
    echo "WARNING: If nothing below, it mean no SSL certificates!"
    echo "Starting get SSL Cer..."
    cat /tmp/ssl.tmp | grep -Pzo '\* Server certificate:((.|\n)*(\.\n))'
    rm -rf /tmp/ssl.tmp
}

bannerAuthor() {
    echo "Welcome to SSL Util"
    echo "Author: Night Barron"
    echo "Last Modified: 01/07/2021"
    echo
}

helpCenter() {
    echo "NAME
    genssl - The SSL tool for create request SSL csr/key file and checking for valid SSL in Domain.

SYNOPSIS
    genssl [options] [domain]

OPTIONS
    -n, --new=domain
            Create new csr/key file for domain to verify.

    -c, --check=domain
            Make a checking if SSL for domain is valid or not.

    -h, --help
            Show help options for genssl tool."
}

main() {
    option=$1
    domain=$2
    bannerAuthor
    if [[ ${option} = "-n" || ${option} = "--new" ]]
    then
        createSSL $domain
    elif [[ ${option} = "-c" || ${option} = "--check" ]]
    then
        checkSSL $domain
    elif [[ ${option} = "-h" || ${option} = "--help" ]]
    then
        helpCenter
    else
        echo "Invalid options! Type -h or --help to see more."
    fi
    echo "Exit!"
    exit 0
}

main $1 $2