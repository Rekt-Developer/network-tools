#!/bin/bash

VERSION="1.0"
TELEGRAM_CHANNEL="https://t.me/RektDevelopers"

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Progress bar function
progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    local fill
    while [ $progress -le 100 ]; do
        let fill=($progress*$width/100)
        printf "\r[%-${width}s] %d%%" $(printf "#%.0s" $(seq 1 $fill)) $progress
        sleep $duration
        let progress+=2
    done
    echo
}

# Animated banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ███╗   ██╗███████╗████████╗████████╗ ██████╗  ██████╗ ██╗     ███████╗
    ████╗  ██║██╔════╝╚══██╔══╝╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝
    ██╔██╗ ██║█████╗     ██║      ██║   ██║   ██║██║   ██║██║     ███████╗
    ██║╚██╗██║██╔══╝     ██║      ██║   ██║   ██║██║   ██║██║     ╚════██║
    ██║ ╚████║███████╗   ██║      ██║   ╚██████╔╝╚██████╔╝███████╗███████║
    ╚═╝  ╚═══╝╚══════╝   ╚═╝      ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${GREEN}Network Tools v${VERSION} - by Rekt Developer Team${NC}"
    echo -e "${BLUE}${TELEGRAM_CHANNEL}${NC}\n"
}

# Self-repair function
self_repair() {
    local error_code=$1
    echo -e "${YELLOW}Attempting to fix error ${error_code}...${NC}"
    case $error_code in
        1)
            # Permission error
            chmod +x "$0"
            ;;
        2)
            # Missing dependencies
            if command -v pkg >/dev/null 2>&1; then
                pkg install -y net-tools iproute2 nmap
            elif command -v apt >/dev/null 2>&1; then
                apt install -y net-tools iproute2 nmap
            fi
            ;;
        *)
            echo -e "${RED}Unknown error. Please report this issue on GitHub${NC}"
            ;;
    esac
}

# Network scanning function with advanced output
scan_network() {
    echo -e "${CYAN}Scanning network interfaces...${NC}"
    progress_bar 0.1
    
    echo -e "\n${GREEN}Network Interfaces:${NC}"
    ip -c a | grep -E "inet|inet6"
    
    echo -e "\n${GREEN}Active Connections:${NC}"
    ss -tuln | grep LISTEN
    
    echo -e "\n${GREEN}Network Statistics:${NC}"
    netstat -i
    
    if command -v nmap >/dev/null 2>&1; then
        echo -e "\n${GREEN}Local Network Scan:${NC}"
        local_ip=$(ip route get 1 | awk '{print $7;exit}')
        nmap -sn "${local_ip}/24" | grep "Nmap scan"
    fi
}

# Main menu
show_menu() {
    echo -e "\n${BOLD}Available Commands:${NC}"
    echo -e "${CYAN}1.${NC} Quick Scan (scan)"
    echo -e "${CYAN}2.${NC} Full Network Analysis (analyze)"
    echo -e "${CYAN}3.${NC} Monitor Network (monitor)"
    echo -e "${CYAN}4.${NC} Join Telegram Channel (telegram)"
    echo -e "${CYAN}5.${NC} Update Tool (update)"
    echo -e "${CYAN}6.${NC} Exit (exit)\n"
}

# Command handler
handle_command() {
    case $1 in
        "scan"|"1")
            scan_network
            ;;
        "analyze"|"2")
            echo -e "${YELLOW}Starting full network analysis...${NC}"
            # Add comprehensive network analysis here
            ;;
        "monitor"|"3")
            echo -e "${YELLOW}Starting network monitoring...${NC}"
            # Add network monitoring here
            ;;
        "telegram"|"4")
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$TELEGRAM_CHANNEL"
            elif command -v termux-open-url >/dev/null 2>&1; then
                termux-open-url "$TELEGRAM_CHANNEL"
            else
                echo -e "${YELLOW}Please visit: ${CYAN}${TELEGRAM_CHANNEL}${NC}"
            fi
            ;;
        "update"|"5")
            echo -e "${YELLOW}Checking for updates...${NC}"
            git pull origin main
            ;;
        "exit"|"6")
            echo -e "${GREEN}Thank you for using Network Tools!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid command. Please try again.${NC}"
            ;;
    esac
}

# Main execution
main() {
    show_banner
    
    while true; do
        show_menu
        read -p "Enter command: " cmd
        handle_command "$cmd"
    done
}

# Error handling
set -e
trap 'self_repair $?' ERR

# Start the program
main
