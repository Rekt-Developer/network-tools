#!/bin/bash

# Enhanced Network Tools v1.0
# By Rekt Developer Team

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Bangla Unicode characters
BANGLA_SCAN="স্ক্যান"
BANGLA_MONITOR="মনিটর"
BANGLA_ANALYZE="বিশ্লেষণ"
BANGLA_UPDATE="আপডেট"
BANGLA_EXIT="প্রস্থান"

# Advanced banner with spinning animation
show_banner() {
    clear
    # ASCII art frames for animation
    local -a frames=(
        "╔════╗ ╔═╗ ╔═╗ ╔════╗"
        "║╔╗╔╗║ ║║╚╗║║║ ║╔╗╔╗║"
        "╚╝║║╚╝ ║╔╗╚╝║║ ╚╝║║╚╝"
        "  ║║   ║║╚╗║║║   ║║  "
        "  ║║   ║║ ║║║║   ║║  "
        "  ╚╝   ╚╝ ╚═╝╚╝   ╚╝  "
    )
    
    for frame in "${frames[@]}"; do
        echo -en "\r${CYAN}${frame}${NC}"
        sleep 0.1
    done
    echo -e "\n\n${GREEN}Network Tools v1.0 • নেটওয়ার্ক টুলস${NC}\n"
}

# Advanced progress bar with percentage
progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    while [ $progress -le 100 ]; do
        local filled=$((progress*width/100))
        local empty=$((width-filled))
        printf "\r[${GREEN}"
        printf "█%.0s" $(seq 1 $filled)
        printf "${NC}"
        printf "░%.0s" $(seq 1 $empty)
        printf "] ${YELLOW}%d%%${NC}" $progress
        sleep $duration
        progress=$((progress+2))
    done
    echo
}

# Network scanning with advanced features
advanced_scan() {
    echo -e "${CYAN}🔍 Advanced Network Scan • উন্নত নেটওয়ার্ক স্ক্যান${NC}"
    progress_bar 0.05
    
    # Interface detection
    echo -e "\n${GREEN}📡 Network Interfaces • নেটওয়ার্ক ইন্টারফেস${NC}"
    ip -c a | grep -E "inet|inet6"
    
    # Port scanning
    echo -e "\n${GREEN}🔌 Open Ports • ওপেন পোর্ট${NC}"
    nmap -F localhost
    
    # Network statistics
    echo -e "\n${GREEN}📊 Statistics • পরিসংখ্যান${NC}"
    netstat -i
}

# Real-time monitoring
monitor_network() {
    echo -e "${CYAN}📊 Network Monitor • নেটওয়ার্ক মনিটর${NC}"
    local count=0
    while [ $count -lt 10 ]; do
        clear
        echo -e "${YELLOW}Real-time Statistics • রিয়েল-টাইম পরিসংখ্যান${NC}"
        ifconfig | grep "RX packets\|TX packets"
        sleep 1
        ((count++))
    done
}

# Security check function
security_check() {
    echo -e "${CYAN}🛡️ Security Check • সুরক্ষা পরীক্ষা${NC}"
    progress_bar 0.05
    
    # Firewall status
    echo -e "\n${GREEN}Firewall Status • ফায়ারওয়াল স্ট্যাটাস${NC}"
    if command -v ufw >/dev/null; then
        ufw status
    else
        echo "Firewall not installed"
    fi
    
    # Open ports check
    echo -e "\n${GREEN}Open Ports • খোলা পোর্ট${NC}"
    ss -tuln
}

# Main menu with bilingual support
show_menu() {
    echo -e "\n${BOLD}Available Commands • উপলব্ধ কমান্ড${NC}"
    echo -e "${CYAN}1.${NC} Scan • ${BANGLA_SCAN}"
    echo -e "${CYAN}2.${NC} Monitor • ${BANGLA_MONITOR}"
    echo -e "${CYAN}3.${NC} Analyze • ${BANGLA_ANALYZE}"
    echo -e "${CYAN}4.${NC} Update • ${BANGLA_UPDATE}"
    echo -e "${CYAN}5.${NC} Exit • ${BANGLA_EXIT}\n"
}

# Main execution loop
main() {
    show_banner
    
    while true; do
        show_menu
        read -p "Enter command • কমান্ড লিখুন: " cmd
        
        case $cmd in
            "scan"|"1")
                advanced_scan
                ;;
            "monitor"|"2")
                monitor_network
                ;;
            "analyze"|"3")
                security_check
                ;;
            "update"|"4")
                echo -e "${YELLOW}Checking for updates...${NC}"
                git pull origin main
                ;;
            "exit"|"5")
                echo -e "${GREEN}Thank you • ধন্যবাদ!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid command • অবৈধ কমান্ড${NC}"
                ;;
        esac
    done
}

# Error handling with self-repair
set -eE
trap 'error_handler $? $LINENO' ERR

error_handler() {
    echo -e "${RED}Error $1 occurred on line $2${NC}"
    echo -e "${YELLOW}Attempting to repair...${NC}"
    chmod +x "$0"
    check_dependencies
}

# Start the program
main
