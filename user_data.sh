#!/bin/bash

yum update -y
yum install -y cronie
yum install -y ss

systemctl enable crond
systemctl start crond

cat <<'EOF' > /root/sysinfo.sh
#!/bin/bash
# Write system info to /var/log/sysinfo

echo "---- System Info ----" >> /var/log/sysinfo
echo "Date and Time: $(date)" >> /var/log/sysinfo
echo "Uptime, Logged-in Users, and CPU Load:" >> /var/log/sysinfo
w >> /var/log/sysinfo
echo "Memory Usage:" >> /var/log/sysinfo
free -m >> /var/log/sysinfo
echo "Disk Space Usage:" >> /var/log/sysinfo
df -h >> /var/log/sysinfo
echo "Open TCP Ports:" >> /var/log/sysinfo
ss -tulpn >> /var/log/sysinfo
echo "Checking connection to ukr.net:" >> /var/log/sysinfo
ping -c1 -w1 ukr.net >> /var/log/sysinfo
echo "SUID Programs:" >> /var/log/sysinfo
find / -perm /4000 -type f 2>/dev/null >> /var/log/sysinfo
echo "---- End of Entry ----" >> /var/log/sysinfo
EOF

chmod +x /root/sysinfo.sh

echo "* * * * 1-5 root /root/sysinfo.sh" >> /etc/crontab
