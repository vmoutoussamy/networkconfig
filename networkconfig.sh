#! /bin/bash
# Version 1.5 2019-11-04
# This script allows to show network information for macOS in one place and
# allow to modify the DNS configuration for a given interface. It mainly use the
# networksetup command line to fetch and set DNS. The ip cli is only use to
# fetch routes.

IFS=$'\n'
listAllNetServ=($(networksetup -listallnetworkservices | grep -v asterisk))

function showAllNetServDNS {
  echo "## DNS server for Ethernet and Wi-Fi Only:"
  for i in "${listAllNetServ[@]}"
  do
    if [ "$i" = "iPhone USB" ] || [ "$i" = "Bluetooth PAN" ] || [ "$i" = "USB Ethernet" ] || [ "$i" = "Thunderbolt Bridge" ]
    then
      continue
    fi
    result=`networksetup -getdnsservers "$i"`
    echo "### $i ###"
    echo "$result"
    echo ""
  done
}

function selectNetServ {
  order=0
  for i in "${listAllNetServ[@]}"
  do
    order=$((order+1))
    echo "$order) $i"
  done
  read number
  number=$((number-1))
  devicename=`networksetup -listallhardwareports | grep -A 1 ${listAllNetServ[($number)]} | grep -v "Hardware Port:" | awk '{print $2}'`
}

echo "# Please select: 1) getInfo, 2)showDNS ,3) setDNS"
read conf

case "$conf" in
  1 )
    # 1) getInfo
    echo "## Please select the number of the desired interface"
    selectNetServ
    echo ""
    echo "####################################"
    echo "### ${listAllNetServ[($number)]} ($devicename) ###"
    echo "####################################"
    echo ""
    echo "### Network Setup Info ($devicename) ###"
    networksetup -getinfo "${listAllNetServ[($number)]}" | grep -v "Client ID:"
    result=`networksetup -getdnsservers "${listAllNetServ[($number)]}"`
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
    # 2) showDNS
    showAllNetServDNS
    ;;
  3 )
    # 3) setDNS
    echo "## Please provide an interface name from the list below"
    selectNetServ
    echo ""
    echo "## Please provide the first dns servers"
    read dnsservers1
    echo "## Please provide the second dns servers"
    read dnsservers2
    echo "${listAllNetServ[($number)]}"
    networksetup -setdnsservers ${listAllNetServ[($number)]} $dnsservers1 $dnsservers2
    result=`networksetup -getdnsservers "${listAllNetServ[($number)]}"`
    echo "### DNS servers for \"${listAllNetServ[($number)]}\" ($devicename): ###"
    echo "$result"
    ;;
  *)
    echo "## ERROR: Please select: 1) getInfo, 2) showDNS, 3) setDNS"
    ;;
esac
