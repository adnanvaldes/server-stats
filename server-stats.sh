# Total CPU usage

totalCPU () {
    # diving by cores to get total CPU utilization
    ps -eo pcpu | awk -v cores=$(nproc) '{total += $1} END {print total / cores}'
}


# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)

diskUsage () {
    df -h --total | grep "/" -w | awk '{split($1, arr, "/"); print "Device:", arr[length(arr)], "\nUsage:", $2, $3, $4, $5}'
}

# Top 5 processes by CPU usage
# Top 5 processes by memory usage


# Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.

totalCPU
diskUsage