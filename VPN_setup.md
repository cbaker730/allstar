Many thanks to KG4FJC's youtube video: https://www.youtube.com/watch?v=z7Dmwx_EGSA


# Create droplet or instance


# Configure droplet

    sudo nano /etc/sysctl.conf

    # Uncomment the next line to enable packet forwarding for IPv4
    net.ipv4.ip_forward=1

    sysctl -p


# Configure server

    apt install wireguard -y

    cd /etc/wireguard
    umask 077; wg genkey | tee privatekey | wg pubkey > publickey
    cat privatekey    # save locally

    nano /etc/wireguard/wg0.conf

    [Interface]
    PrivateKey = <PASTE_HERE>
    Address = 10.10.10.1/24
    ListenPort = 51820
    PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

    
    systemctl enable wg-quick@wg0                # auto-start wireguard at boot

    systemctl enable wg-quick@wg0


# Configure client

    apt install openresolv

    cd /etc/wireguard

    wg genkey | sudo tee /etc/wireguard/client_private.key | wg pubkey | sudo tee /etc/wireguard/client_public.key

    nano /etc/wireguard/wg0.conf

    [Interface]
    PrivateKey = 
    Address = <private_ip_of_client (.2)>/32
    DNS = 8.8.8.8
    MTU = 1500
    
    [Peer]
    PublicKey = 
    AllowedIPs = 0.0.0.0/0
    Endpoint = <public_ip>:51820
    PersistentKeepalive = 25


    systemctl start wg-quick@wg0.service        # Start service

    systemctl enable wg-quick@wg0.service       # Enable at boot


# Complete server config

    nano /etc/wireguard/wg0.conf

    [Interface]
    PrivateKey = <PASTE_HERE>
    Address = 10.10.10.1/24
    ListenPort = 51820
    PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
    
    [Peer]
    # Allstar node
    PublicKey = <client_public_key>
    AllowedIPs = 10.0.74.2/24



    apt install ufw
    
    ufw allow 22/tcp
    ufw allow 51820/udp
    ufw disable
    ufw enable
    ufw status

    wg-quick up wg0
    wg show

# Make sure the firewall on the droplet or instance allows inbound 51820/udp

    wg-quick down wg0
    wg-quick up wg0

    host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has"

    This should be the public IP address of the VPN / proxy server



    
