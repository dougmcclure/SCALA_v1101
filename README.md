## SCALA v1101 Demos

### Demonstration of SCALA v1101 and assoicated Insight Packs (WAS, DB2, Syslog, Generic) as well as a custom app demo for the Syslog Insight Pack

Readme
--------------------
Installing IBM's Smart Cloud Analytics Log Analysis (SCALA, aka Log Analytics).  

To install and run the single box scenario :

1. Install Virtualbox (https://www.virtualbox.org/) (tested using 4.2.12 on Windows 7)
2. Install Vagrant (http://www.vagrantup.com/) (tested using v1.2.2 on Windows 7)
3. Download the git repo using either ```git clone https://github.com/dougmcclure/UPDATE THIS.git``` or download the repo as a .zip file and unzip
4. Download SCALA v1101 Trial Version (https://www.ibm.com/developerworks/servicemanagement/bsm/log/downloads.html) and place in the /shared/box1-files directory of the repo
5. Download the WAS and DB2 Insight Pack zip files and place in the /shared/box1-files/InsightPacks directory of the repo
6. Open a terminal or Windows command shell and navigate to the box1-scala-v1101 repo directory. Issue the ```vagrant up``` command.
7. Point your supported browser to https://10.10.10.2:9987/Unity and login with 'unityamdin' and password 'unityadmin'
8. To SSH to the image, use putty to 10.10.10.2 and login with 'scla' and password 'scla'

Notes:

* If you want to suspend the image for future use, run the ```vagrant suspend``` command to store the image and associated configurations. To restart, issue the ```vagrant resume``` command.
* Each time you run the ```vagrant up``` command, the entire proceses is repeated, including fresh pre-req downloading and provisioning. To speed up that process, comment out the ```config.vm.provision :shell, :path => "../download_prereq.sh"``` line in box1's Vagrant file to prevent repetitive downloading of the pre-reqs.


This work is offered as-is for community use. My ideas and contributions are my own. All materials are posted by me as an individual and are not an expression of support, acceptance or approval of my employer IBM. All materials are to be used within a testing environment and should not be considered worthy of production use without further review and optimization.
