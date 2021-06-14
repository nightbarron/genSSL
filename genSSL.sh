#!/bin/bash
read -p "Enter Domain: " domainName
read -p "Enter Organization: " organName
read -p "Enter Province: " provinceName
read -p "Enter location to save ${domainName}.csr, ${domainName}.key (ENTER FOR CURRENT): " location

fileName=${domainName/"*"/"_"}
echo File: $fileName
echo Domain: $domainName

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

echo "Location: ${location}"

{
    openssl req -new -newkey rsa:2048 -nodes -out "${location}/${fileName}.csr" -keyout "${location}/${fileName}.key" \
     -subj "/C=VN/ST=${provinceName}/L=${provinceName}/O=${organName}/OU=IT Department/CN=${domainName}/emailAddress=webmaster@${domainName}"
} || {
    echo "Cannot create SSL at \"${location}\"!!!"
    exit 1
}

exit 0