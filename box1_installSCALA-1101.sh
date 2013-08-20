#!/bin/bash
# Vagrant provisioning script for SCALA OpenBeta Drivers
#
#Doug McClure
#v1.0 3/24/13
#v1.1 4/4/13  Enhancements + changes from c835722 for getting things to work on a CentOS 6.4 box
#v1.2 4/8/13  Enhancements for multi-box scenario #1 - one master SCALA box + one remote LFA box
#v1.3 4/10/13 Added a script timer
#v1.4 4/11/13 Added steps to install original sampleScenario data plus new WebSphere Liberty Demo 
#			  configurations (for multi-box scenario)
#v1.5 4/12/13 Moving all download steps out of this provisioning script and into separate provisioning script
#v1.6 4/25/13 Updates for Milestone Driver #2
#v1.7 5/21/13 Updates for Milestone Driver #3
#v1.8 6/12/13 Updates for GA Release Version (new driver name and silent install file)
#v1.9 7/14/13 Updates to install the WAS and DB2 Insight Packs, Configured for SampleScenario Data
#v1.10 8/6/13: Updates to support SCALA v1.1.0.1 Trial Version, add step to increase the retention period to 90 days
#v1.10 8/13/13: Added installation for SyslogInsightPack_v1.1.0.zip and GAInsightPack_v1.1.1.zip
#
#
########################################################################################################
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

# filename for driver

#GA Release Driver: v1.1.0.0
#DRIVER_NAME="CIMM3EN.tar.gz"

#GA Release Driver v1.1.0.1
DRIVER_NAME="CIP74EN.tar.gz"

GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="$BASE_DIR/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"

echo "[SCALA] Turning off SELINUX on this CentOS Box"

#turn off selinux

sudo /usr/sbin/setenforce 0
sudo cp $SHARED_DIR/selinux /etc/sysconfig/selinux

echo "[SCALA] SELINUX Turned Off"

echo "[SCALA] Changing /etc/redhat-release to spoof IIM"
#change the /etc/redhat-release

sudo cp $SHARED_DIR/redhat-release /etc/redhat-release

echo "[SCALA] /etc/redhat-release changed"

echo "[SCALA] Install PREREQ for SCALA Box"

### is there a way to lay down without yum going online to do dep checks? just using rpm command maybe??

sudo yum -y localinstall $PREREQ_DIR/common/*.rpm

echo "[SCALA] Change iptables rules to allow SCALA to always work" 

#to turn it off for this sesssion to turn it off perm --> sudo chkconfig iptables off
#
#if you do a vagrant suspend or halt then you'll have to rerun this command again (assuming you're not provisioning again)
#
sudo service iptables stop

echo "[SCALA] Fixed iptables rules to allow SCALA to always work" 

echo "[SCALA] Creating Install User and Group"
#create scla user and group

groupadd $GROUP_NAME
useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[SCALA] Install User and Group Created"

echo "[SCALA] Create Directories"
# create base and install directories

sudo mkdir -p $INSTALL_DIR

echo "[SCALA] Directories Created"

echo "[SCALA] Explode the Tarball"

tar -C $BASE_DIR -zxf $SHARED_DIR/box1-files/$DRIVER_NAME 

echo "[SCALA] Driver Exploded"

echo "[SCALA] Change Ownership"

sudo chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[SCALA] Install Driver"
#install

#some weird errors at the start that seem harmless - logfile permissions to write?
#/opt/scla/install.sh: line 34: install.log: Permission denied

sudo -u $USERNAME $BASE_DIR/install.sh -s $SHARED_DIR/box1-files/SCALA-GA-Vagrant-silent_install.xml

#some weird errors at the end that seem harmless?
#/opt/scla/install.sh: line 34: install.log: Permission denied

echo "[SCALA] Driver Installed"

echo "[SCALA] Install SCALA Sample Data"

#add the install of Daytrader sample scenario

echo "[SCALA] Need to change to the directory to install data"

#apply hotfix for bug in admin.py where hostnames with '-' in them fails
#IS THIS STILL NEEDED?
#sudo -u $USERNAME cp $SHARED_DIR/box1-files/admin.py $INSTALL_DIR/utilities

#Might need to sleep for a while here to allow SCALA processes to spin up completely (might be system resources on my laptop)
#if the sample scenrio fails to load, uncomment this line and adjust sleep time as needed
sleep 90

cd $INSTALL_DIR/sampleScenarios/

sudo -u $USERNAME perl CreateSampleScenario.pl

echo "[SCALA] SCALA Sample Data Installed"

echo "[SCALA] Install Insight Packs"

sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -install $SHARED_DIR/box1-files/InsightPacks/DB2AppInsightPack_v1.1.0.zip
sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -install $SHARED_DIR/box1-files/InsightPacks/WASAppInsightPack_v1.1.0.zip

sudo -u $USERNAME cp $SHARED_DIR/box1-files/InsightPacks/GAInsightPack_v1.1.1.zip $INSTALL_DIR/unity_content/
sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -upgrade $INSTALL_DIR/unity_content/GAInsightPack_v1.1.1.zip 
sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -deploylfa $INSTALL_DIR/unity_content/GAInsightPack_v1.1.1.zip -f

sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -install $SHARED_DIR/box1-files/InsightPacks/SyslogInsightPack_v1.1.0.zip
sudo -u $USERNAME $INSTALL_DIR/utilities/pkg_mgmt.sh -deploylfa $SHARED_DIR/box1-files/InsightPacks/SyslogInsightPack_v1.1.0.zip -f

#install hot fix file for CommonAppMod.py to address json/simplejson error -- not fixed until v1.1.0.2

sudo -u $USERNAME cp $SHARED_DIR/box1-files/InsightPacks/CommonAppMod.py $INSTALL_DIR/AppFramework/Apps/DB2AppInsightPack_v1.1.0/
sudo -u $USERNAME cp $SHARED_DIR/box1-files/InsightPacks/CommonAppMod.py $INSTALL_DIR/AppFramework/Apps/WASAppInsightPack_v1.1.0/

#install customized InsightPack configuration to allow them to work with SampleScenario data for DayTrader

sudo -u $USERNAME cp $SHARED_DIR/box1-files/InsightPacks/DB2_Troubleshooting.app $INSTALL_DIR/AppFramework/Apps/DB2AppInsightPack_v1.1.0/
sudo -u $USERNAME cp $SHARED_DIR/box1-files/InsightPacks/WAS_Troubleshooting.app $INSTALL_DIR/AppFramework/Apps/WASAppInsightPack_v1.1.0/


echo "[SCALA] SCALA InsightPacks Installed"

echo "how long does this provisioning script take?"

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Started: $SCRIPT_START
echo Script Ended: $(date)
echo Script Total Time: $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0