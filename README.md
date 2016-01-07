# eja_dicom cookbook

# Requirements
64-bit OS
Ubuntu 12.04 LTS or Ubuntu 14.04 LTS

# Usage
Include the default recipe to install and start the dicom service from the eja-dicom package. Set attributes as required for your installation. See the attributes heading below.

# Attributes
The attributes used by this cookbook are under the 'eja_dicom' namespace.

|Attribute        | Description |Type | Default|
|-----------------|-------------|-----|--------|
port|The listening port for the dicom server|Fixnum|10104
output_directory|The directory where the dicom server will store images it receives|String|/opt/dicom_output
output_directory_mode|The octal unix permission mode of the output_directory|Fixnum|00750
aet|The Application Entity Name of this dicom server. Set as appropriate for your environment|String|eja_dicom
logfile|The log file for the dicom server|String|/var/log/eja-dicom.log
install_root|The base directory where the eja-dicom software subdirectory will be created|String|/opt
install_dirname|The subdirectory that will be created in install_root where this cookbook will extract the eja-dicom software to|String|eja-dicom
script_location|The location where the dicom.sh startup script will be created|String|#{node[:eja_dicom][:install_root]}/#{node[:eja_dicom][:install_dirname]}/dicom.sh
user|The username that the dicom server will run as and that the output_directory will be owned by. Will be created if it doesn't exist.|String|dicom
group|The group name that the dicom server will run as and that the output_directory will be owned by. Will be created if it doesn't exist.|String|dicom
source|The URL source for the eja-dicom distro.|String|http://www.cmrr.umn.edu/~bdhanna/eja-dicom-distro.tgz

# Recipes
- default: Installs and starts the eja-dicom server.
- ubuntu-precise-amd64: Install libraries required to run the eja-dicom software on 64-bit Ubuntu Precise

# Author

Author:: Adam Mielke, (C) Regents of the University of Minnesota (<adam@umn.edu>)
