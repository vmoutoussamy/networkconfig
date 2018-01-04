#! /bin/bash
# Version 1.0 2018-01-04
# This script allow to show network information for macOS in one place and allow
# to modify the DNS configuration for a given interface. It mainly use the 
# networksetup command line to fetch and set DNS. The ip cli is only use to 
# fetch routes.

function selectnetworkservice {
  IFS=$'\n'
  listallnetworkservices=($(networksetup -listallnetworkservices | grep -v asterisk))
  order=0
  for i in "${listallnetworkservices[@]}" 
  do
    order=$((order+1))
    echo "$order) $i"
  done
  read number
  number=$((number-1))
  devicename=`networksetup -listallhardwareports | grep -A 1 ${listallnetworkservices[($number)]} | grep -v "Hardware Port:" | awk '{print $2}'`
}

echo "# Please select: 1) getinfo, 2) setdnsservers"
read conf

case "$conf" in
  1 ) 
    # 1) getinfo
    echo "## Please select the number of the desired interface"
    selectnetworkservice
    echo ""
    echo "####################################"
    echo "### ${listallnetworkservices[($number)]} ($devicename) ###"
    echo "####################################"
    echo ""
    echo "### Network Setup Info ($devicename) ###"
    networksetup -getinfo "${listallnetworkservices[($number)]}" | grep -v "Client ID:"
    result=`networksetup -getdnsservers "${listallnetworkservices[($number)]}"`
    echo ""
    echo "### DNS servers ($devicename) ###"
    echo "$result"
    echo ""
    echo "### Routes ($devicename) ###"
    ip r s | grep $devicename
    echo ""
    echo "### Other routes ###"
    ip r s | grep -v $devicename
    ;;
  2 ) 
    # 2) setdnsservers
    echo "## Please provide an interface name from the list below"
    selectnetworkservice
    echo ""
    echo "## Please provide the first dns servers"
    read dnsservers1
    echo "## Please provide the second dns servers"
    read dnsservers2
    echo "${listallnetworkservices[($number)]}"
    networksetup -setdnsservers ${listallnetworkservices[($number)]} $dnsservers1 $dnsservers2
    result=`networksetup -getdnsservers "${listallnetworkservices[($number)]}"`
    echo "### DNS servers for \"${listallnetworkservices[($number)]}\" ($devicename): ###"
    echo "$result"
    ;;
  *) 
    echo "## ERROR: Please select: 1) getinfo, 2) setdnsservers"
    ;;
esac