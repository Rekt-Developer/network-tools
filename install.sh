#!/bin/bash

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fancy banner
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "████████╗ ██████╗  ██████╗ ██╗     ███████╗"
    echo "╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝"
    echo "   ██║   ██║   ██║██║   ██║██║     ███████╗"
    echo "   ██║   ██║   ██║██║   ██║██║     ╚════██║"
    echo "   ██║   ╚██████╔╝╚██████╔╝███████╗███████║"
    echo "   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝"
    echo -e "${NC}"
    echo -e "${GREEN}Network Tools Installer v1.0${NC}"
    echo -e "${BLUE}By Rekt Developer Team${NC}"
    echo
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

install_dependencies() {
    echo -e "\n${YELLOW}Installing dependencies...${NC}"
    
    if command -v pkg >/dev/null 2>&1; then
        # Termux
        pkg update -y
        pkg install -y git python net-tools iproute2 nmap curl wget dialog termux-api
    elif command -v apk >/dev/null 2>&1; then
        # Alpine
        apk update
        apk add git python3 net-tools iproute2 nmap curl wget dialog
    elif command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        apt update
        apt install -y git python3 net-tools iproute2 nmap curl wget dialog
    else
        echo -e "${RED}Unsupported package manager${NC}"
        exit 1
    fi
}

check_python() {
    if command -v python3 >/dev/null 2>&1; then
        python3 -m pip install --upgrade pip
        python3 -m pip install requests python-telegram-bot rich
    else
        echo -e "${RED}Python3 is required but not installed.${NC}"
        exit 1
    fi
}

join_telegram() {
    echo -e "\n${BLUE}Opening Telegram channel...${NC}"
    if command -v termux-open-url >/dev/null 2>&1; then
        termux-open-url "https://t.me/RektDevelopers"
    else
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open "https://t.me/RektDevelopers"
        else
            echo -e "${YELLOW}Please join our Telegram channel: ${CYAN}https://t.me/RektDevelopers${NC}"
        fi
    fi
}

main() {
    print_banner
    
    echo -e "${YELLOW}Starting installation...${NC}"
    
    # Install dependencies
    install_dependencies &
    spinner $!
    
    # Check Python and install requirements
    check_python &
    spinner $!
    
    # Clone repository
    echo -e "\n${YELLOW}Cloning repository...${NC}"
    git clone https://github.com/Rekt-Developer/network-tools.git &
    spinner $!
    
    # Setup permissions
    cd network-tools
    chmod +x nettools.sh
    
    echo -e "\n${GREEN}Installation completed!${NC}"
    
    # Join Telegram channel
    join_telegram
    
    echo -e "\n${GREEN}To start using Network Tools:${NC}"
    echo -e "${CYAN}cd network-tools${NC}"
    echo -e "${CYAN}./nettools.sh${NC}"
}

main
