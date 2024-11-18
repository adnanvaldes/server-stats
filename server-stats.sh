# Total CPU usage

totalCPU () {
    # diving by cores to get total CPU utilization
    ps -eo pcpu | awk -v cores=$(nproc) '{total += $1} END {print sprintf("CPU Load: %.1f", total / cores)"%"}'

}

# Total memory usage (Free vs Used including percentage)
totalMem () {
    free -h | awk '
    function percentage(part, total) {
        return sprintf("%.1f%%", (part / total * 100))
    }
    NR==2 {
        print "Total:", $2, \
              "\nUsed:", $3, percentage($3, $2), \
              "\nFree:", $4, percentage($4, $2), \
              "\nCache:", $6, percentage($6, $2)
    }'
}

# Total disk usage (Free vs Used including percentage)
diskUsage () {
    df -h --total | grep "/" -w | awk '{split($1, arr, "/"); print "Device:", arr[length(arr)], "\nUsage:", $2, $3, $4, $5}'
}

# Top 5 processes by CPU usage
topCPUProcs () {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}
# Top 5 processes by memory usage
topMemProcs () {
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
}

# Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.

totalCPU
totalMem
diskUsage
topCPUProcs
topMemProcs