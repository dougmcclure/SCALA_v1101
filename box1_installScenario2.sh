#!/bin/bash
# 
# Scenario2 -> Local Box Syslog (normal /var/log/* plus SCALA) -> Consolidated KVP File -> LFA -> SCALA Generic Annotator
#
#Doug McClure
#v1.0 5/1/13 First pass for Scenario2 on box1
#v1.1 5/21/13 Updates for Milestone Driver #3
#v1.2 7/14/13 Updates for GA Trial Version
#v1.3 8/6/13  Verified OK for SCALA v1.1.0.1 Trial Version
########################################################################################################
#Uncomment this to see verbose install
set -x

#how long does this provisioning script take?
SCRIPT_START=$(date +%s)
echo Started : $(date)

#variables
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="/opt/scla/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"

#####

#Copy SyslogDemo1 directory with files for provisioning SCALA (ST, C, LS, QS) to sampleScenario folder

sudo -u $USERNAME cp -R $SHARED_DIR/box1-files/SyslogDemo1 $INSTALL_DIR/sampleScenarios

#must be in this directory to execute perl script

cd $INSTALL_DIR/sampleScenarios/

#install SyslogDemo1 Demo configurations (collection, log sources, saved searches)

sudo -u $USERNAME perl CreateSampleScenario.pl 9987 unityadmin unityadmin SyslogDemo1/SyslogDemo1.def

#box1 - new rsyslog.conf file 
#- identify monitored files and creation of output file using SCALA KVP template
#- make sure output file writes to a unique file name so we can identify each box in SCALA 
#box1 - write file to monitored GA directory /opt/scla/driver/logsources/GAContentPack/box1-syslog.log

sudo cp $SHARED_DIR/box1-files/box1-rsyslog.conf /etc/rsyslog.conf

#restart rsyslog

sudo service rsyslog restart

#Install Syslog Insight Pack Demo App

#create directory

sudo -u $USERNAME mkdir $INSTALL_DIR/AppFramework/Apps/SyslogCustomAppDemo

#copy CommonAppMod.py from WAS InsightPack
sudo -u $USERNAME cp $INSTALL_DIR/AppFramework/Apps/WASAppInsightPack_v1.1.0/CommonAppMod.py $INSTALL_DIR/AppFramework/Apps/SyslogCustomAppDemo

#copy files
sudo -u $USERNAME cp $SHARED_DIR/box1-files/SyslogCustomAppDemo/* $INSTALL_DIR/AppFramework/Apps/SyslogCustomAppDemo


#####
#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0