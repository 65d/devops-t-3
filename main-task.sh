#!/bin/bash

INSTANCE_IP=""
SSH_KEY_PATH=""
SSH_USER="ec2-user"

ssh -i $SSH_KEY_PATH $SSH_USER@$INSTANCE_IP << 'EOF'

sudo yum -y install cronie
sudo yum install mc -y

sudo bash -c 'cat <<EOL > /root/sysinfo.sh
#!/bin/bash

echo "Current date and time: \$(date)" >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo

echo "System uptime, logged-in users and CPU load" >> /var/log/sysinfo
w >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo

echo "Memory usage and disk space usage" >> /var/log/sysinfo
free -m >> /var/log/sysinfo
df -h >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo

echo "List of programs used open TCP ports" >> /var/log/sysinfo
ss -tulpn >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo

echo "Internet test" >> /var/log/sysinfo
ping -c1 -w1 ukr.net >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo

echo "List of SUID programs" >> /var/log/sysinfo
find / -type f -perm -4000 2>/dev/null >> /var/log/sysinfo
echo "------------------------------------------------------------" >> /var/log/sysinfo


EOL'

sudo chmod +x /root/sysinfo.sh

sudo bash -c 'echo "*/5 * * * * root /root/sysinfo.sh" >> /etc/crontab'

sudo systemctl start crond
sudo systemctl enable crond

EOF

echo "$INSTANCE_IP OK!"