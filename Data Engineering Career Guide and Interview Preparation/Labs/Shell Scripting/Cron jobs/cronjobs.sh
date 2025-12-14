#! /bin/bash
# print the current date time

date

# print the disk free statistics

df -h

# Add a job to crontab and save it with the following script
# This job will run the diskusage script at 9.00PM and store the output to diskusage.log

crontab -e

0 21 * * * /home/project/disksusage.sh >>/home/project/diskusage.log