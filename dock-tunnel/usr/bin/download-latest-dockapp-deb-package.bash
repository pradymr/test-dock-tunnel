#!/bin/bash

#######################################################################################################################
#
# Check s3 for Dock app deb package and downloads the latest version zip file
#
#
#######################################################################################################################

versions=($(aws s3 ls s3://ci-test-dock-builds --recursive | grep -i dock-app-latest_[0-9]*\.[0-9]*\.[0-9]*_ubuntu-arm64 | rev | cut -d' ' -f 1 | rev | cut -d'_' -f 2 ))

max=0.0.0
for v in ${versions[@]}; do
    version1=$max
    version2=$v
    patch1=$(echo $version1 | cut -d'.' -f 3)
    minor1=$(echo $version1 | cut -d'.' -f 2)
    major1=$(echo $version1 | cut -d'.' -f 1)

    patch2=$(echo $version2 | cut -d'.' -f 3)
    minor2=$(echo $version2 | cut -d'.' -f 2)
    major2=$(echo $version2 | cut -d'.' -f 1)

    if [[ $major1 -lt $major2 ]]; then max=$v; 
    elif [[ $major1 -eq $major2 ]]; then 
        if [[ $minor1 -lt $minor2 ]]; then max=$v; 
        elif [[ $minor1 -eq $minor2 ]]; then 
          if [[ $patch1 -lt $patch2 ]]; then max=$v; 
          fi
        fi  
    fi;
done
echo max version is $max  

echo Downloading latest Dockapp version

aws s3 cp s3://mybucket/dock-app-latest_$max_ubuntu-arm64.zip dock-app-latest_$max_ubuntu-arm64.zip
