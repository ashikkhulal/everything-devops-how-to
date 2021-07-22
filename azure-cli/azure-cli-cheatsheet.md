# Azure-cli Cheatsheet:

**Resource Group:**

// create, delete, show & list resource groups:

    $ az group create --location
                      --name
                      --managed-by
                      --subscription
                      --tags

    $ az group delete --name
                      --no-wait
                      --subscription
                      --yes

    $ az group show --name
                    --query
                    --subscription

    $ az group list --query
                    --subscription
                    --tag


**Networking:**

// create, delete & list virtual networks:

    $ az network vnet create --name
                             --resource-group
                             --address-prefixes
                             --dns-servers
                             --location
                             --network-security-group
                             --subnet-name
                             --subnet-prefixes
                             --subscription
                             --tags

    $ az network vnet delete --ids
                             --name
                             --resource-group
                             --subscription  

    $ az network vnet list --query
                           --name
                           --resource-group
                           --subscription

// create, delete & list subnets:

    $ az network vnet subnet create --address-prefixes
                                    --name
                                    --resource-group
                                    --vnet-name
                                    --disable-private-endpoint-network-policies {false, true}
                                    --disable-private-link-service-network-policies {false, true}
                                    --network-security-group
                                    --route-table
                                    --subscription
    
    $ az network vnet subnet delete --name

    $ az network vnet subnet list --resource-group
                                  --vnet-name
                                  --query
                                  --subscription

// create, delete & lists network security groups & rules:

    $ az network nsg create --name
                            --resource-group
                            --location
                            --subscription
                            --tags

    $ az network nsg delete --ids
                            --name
                            --resource-group
                            --subscription

    $ az network nsg list --query
                          --resource-group
                          --subscription

    $ az network nsg rule create --name
                                 --nsg-name
                                 --priority
                                 --resource-group
                                 --access {Allow, Deny}
                                 --description
                                 --destination-address-prefixes
                                 --destination-asgs
                                 --destination-port-ranges
                                 --direction {Inbound, Outbound}
                                 --protocol {*, Ah, Esp, Icmp, Tcp, Udp}
                                 --source-address-prefixes
                                 --source-asgs
                                 --source-port-ranges
                                 --subscription

    $ az network nsg rule delete --ids
                                 --name
                                 --nsg-name
                                 --resource-group
                                 --subscription

    $ az network nsg rule list --nsg-name
                               --resource-group
                               --include-default
                               --query
                               --subscription

**Virtual Machine:**

// create & delete a vm:

    az vm create --name
                 --resource-group
                 --admin-password
                 --admin-username
                 --authentication-type {all, password, ssh}
                 --boot-diagnostics-storage
                 --computer-name
                 --count
                 --custom-data
                 --data-delete-option
                 --data-disk-caching
                 --data-disk-encryption-sets
                 --data-disk-sizes-gb
                 --generate-ssh-keys
                 --image        #visit for image lists: https://az-vm-image.info/
                 --location
                 --nic-delete-option
                 --nics
                 --nsg
                 --nsg-rule {NONE, RDP, SSH}
                 --private-ip-address
                 --public-ip-address
                 --public-ip-address-allocation {dynamic, static}
                 --size         #visit for vm sizes & prices: https://azureprice.net/
                 --ssh-dest-key-path
                 --ssh-key-name
                 --storage-account
                 --storage-container-name
                 --storage-sku
                 --subnet
                 --subnet-address-prefix
                 --subscription
                 --tags
                 --ultra-ssd-enabled {false, true}
                 --user-data
                 --vnet-name

to delete a vm:

    $ az vm delete --force-deletion
                   --ids
                   --name
                   --no-wait
                   --resource-group
                   --subscription
                   --yes