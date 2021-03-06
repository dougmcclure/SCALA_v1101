#!/bin/bash
# Provision main SCALA box for the multi-box scenario1 
# Used for demonstrating IBM Log Analytics Milestone Driver 2
# Main ILA driver and Remote APP+LFA Operations
#
#Doug McClure
#v1.0 4/23/13 Extract the driver2 LFA from main ILA box and place in $SHARED_DIR/lfa
#             Provision the SCALA driver 1 with WebSphere Liberty collection, log sources and saved searches
#v1.1 5/21/13 Updates for Milestone Driver #3
#v1.2 6/12/13 Updates for GA Release Driver
#v1.3 8/6/13  Verified OK for SCALA v1.1.0.1 Trial Version
###############################################################################################################
#System Reference:
#box1-driver: 10.10.10.2
#box2-liberty: 10.10.10.3
#box3-syslog: 10.10.10.4
#box4-      : 10.10.10.5
###################
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
INSTALL_DIR="$BASE_DIR/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"


######
#
# Build out the multi-box scenario1
#
#####
#
echo "[SCALA] Copy LFA Files to shared directory"

mkdir -p $SHARED_DIR/box2-files/lfa/unity_images
mkdir -p $SHARED_DIR/box2-files/lfa/work_files/Configurations/Data_Collector

cp $INSTALL_DIR/setupScripts/ITM_Log_Agent_Setup.sh $SHARED_DIR/box2-files/lfa
cp $INSTALL_DIR/unity_images/LFA_0630.tar.gz $SHARED_DIR/box2-files/lfa/unity_images
cp $INSTALL_DIR/work_files/Configurations/Data_Collector/* $SHARED_DIR/box2-files/lfa/work_files/Configurations/Data_Collector/

echo "[SCALA] LFA Files Ready for Copying to Remote Systems from shared directory"

echo "Install WebSphere Liberty Demo Configuration"

#copy WebSphere Liberty configration files to sampleScenario directory included with milestone driver 

sudo -u $USERNAME cp -R $SHARED_DIR/box1-files/LibertyDemo $INSTALL_DIR/sampleScenarios

#must be in this directory to execute perl script

cd $INSTALL_DIR/sampleScenarios/

#install WebSphere Liberty Demo configurations (collection, log sources, saved searches)

sudo -u $USERNAME perl CreateSampleScenario.pl 9987 unityadmin unityadmin LibertyDemo/LibertyDemo.def

#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0