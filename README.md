# networkconfig

Version 1.0 2018-01-04

This script allow to show network information for macOS in one place and allow
to modify the DNS configuration for a given interface. It mainly use the
networksetup command line to fetch and set DNS. The ip cli is only use to
fetch routes.

```bash
networkconfig                                                                                                                                                                    5:01PM
# Please select: 1) getinfo, 2) setdnsservers
1
# Please select the number of the desired interface
1) Thunderbolt Ethernet
2) Wi-Fi
3) Bluetooth PAN
4) Thunderbolt Bridge
1

####################################
### Thunderbolt Ethernet (en5) ###
####################################

### Network Setup Info (en5) ###
DHCP Configuration
IP address: 10.X.X.X
Subnet mask: 255.255.255.0
Router: 10.X.X.254
IPv6: Off
Ethernet Address: XX:XX:XX:XX:XX:XX

### DNS servers (en5) ###
9.9.9.9
8.8.8.8

### Routes (en5) ###
default via 10.XX.XX.254 dev en5
10.XX.XX.XX/24 dev en5  scope link
255.255.255.255/32 dev en5  scope link

### Other routes ###
127.0.0.0/8 via 127.0.0.1 dev lo0
164.XX.XX.0/16 via 10.XX.X.1 dev utun1
```
