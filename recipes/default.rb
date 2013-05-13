#
# Cookbook Name:: eja_dicom
# Recipe:: default
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

group node[:eja_dicom][:group]

user node[:eja_dicom][:user] do
	gid node[:eja_dicom][:group]
	system true
end

directory node[:eja_dicom][:output_directory] do
	owner node[:eja_dicom][:user]
	group node[:eja_dicom][:group]
	mode 00640
	action :create
end

ark "eja-dicom-distro" do
	url node[:eja_dicom][:source]
	path node[:eja_dicom][:install_path]
	action :put
end

template node[:eja_dicom][:script_location] do
	source "dicom.sh"
	mode 00755
	variables ({
		:aet => node[:eja_dicom][:aet],
		:logfile => node[:eja_dicom][:logfile],
		:output_directory => node[:eja_dicom][:output_directory],
		:port => node[:eja_dicom][:port],
		:install_path => node[:eja_dicom][:install_path]
		})
end

template "/etc/init.d/dicom" do
	mode 00755
	variables ({
		:logfile => node[:eja_dicom][:logfile],
		:script_location => node[:eja_dicom][:script_location],
		:user => node[:eja_dicom][:user]
		})
end

file node[:eja_dicom][:logfile] do
	owner node[:eja_dicom][:user]
	group node[:eja_dicom][:group]
	mode 0640
end

service "dicom" do
	action [ :enable, :start ]
end
