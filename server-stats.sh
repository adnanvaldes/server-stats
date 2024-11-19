# Reset
RESET='\033[0m'  

# Regular Colors
BLACK='\033[0;30m'      
RED='\033[0;31m'        
GREEN='\033[0;32m'       
YELLOW='\033[0;33m'    
BLUE='\033[0;34m' 
PURPLE='\033[0;35m'      
CYAN='\033[0;36m'        
WHITE='\033[0;37m' 

# Total CPU usage
CPUData () {
    # diving by cores to get total CPU utilization
    ps -eo pcpu | awk -v cores=$(nproc) '{total += $1} END {print GREEN sprintf("CPU Load: %.1f", total / cores)"%" }'

    # match and assign the variables we are looking for (architecture and model name)
    lscpu | awk '
        /^Architecture:/ {arch = $2}
        /^Model name:/ {CPU = $3 " " $4 " " $5 " " $6}
        END {
            print "CPU Model:", GREEN CPU RESET
            print "Architecture:", GREEN arch RESET
        }'
    echo -e "Cores: $(nproc)"

}

# Total memory usage (Free vs Used including percentage)
totalMem () {
    free -h | awk '
    function percentage(part, total) {
        return sprintf("%.1f%%", (part / total * 100))
    }
    NR==2 {
        print   "Used:", $3, "/ " \
                "Total:", $2, "("percentage($3, $2)")" \
                "\nFree:", $4, "("percentage($4, $2)")", \
                "\nCache:", $6, "("percentage($6, $2)")"
    }'
}

# Total disk usage (Free vs Used including percentage)
diskUsage () {
    df -h --total -T | grep "/" -w | awk '{split($1, arr, "/"); print "Device:", arr[length(arr)], "("$2")", "\nFree:", $5,"/ Used:", $4, "("$6")"}'
}

# Top 5 processes by CPU usage
topCPUProcs () {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}
# Top 5 processes by memory usage
topMemProcs () {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
}

writeHeader() {
    local start=1
    local end=${1:-80}
    local range=$(seq $start $end)
	for i in $range ; do echo -n "${str}"; done
}

# Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.
printf "
#############################
# Server Performance Report #
#############################\n"

printf "${RESET}\nCPU Data:\n=========\n${GREEN}"
CPUData

printf "${RESET}\nMemory Usage:\n=============\n${YELLOW}"
totalMem

printf "${RESET}\nDisk Usage:\n===========\n${RED}"
diskUsage

printf "${RESET}\nTop 5 CPU processes\n===================\n${CYAN}"
topCPUProcs

printf "${RESET}\nTop 5 MEM processes\n===================\n${WHITE}"
topMemProcs
