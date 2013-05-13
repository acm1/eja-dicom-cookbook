#
# Cookbook Name:: eja_dicom
# Recipe:: default
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

# If this is a 64-bit Ubuntu Precise machine, install required libraries first
if node[:platform] == "ubuntu" and node[:platform_version] == "12.04" and node[:kernel][:machine] =~ /x86_64/
	include_recipe "#{cookbook_name}::ubuntu-precise-amd64"
end

group node[:eja_dicom][:group] do
	system true
end

user node[:eja_dicom][:user] do
	gid node[:eja_dicom][:group]
	system true
end

directory node[:eja_dicom][:output_directory] do
	owner node[:eja_dicom][:user]
	group node[:eja_dicom][:group]
	mode node[:eja_dicom][:output_directory_mode]
	action :create
end

ark node[:eja_dicom][:install_dirname] do
	url node[:eja_dicom][:source]
	path node[:eja_dicom][:install_root]
	action :put
end

template node[:eja_dicom][:script_location] do
	source "dicom.sh.erb"
	mode 00755
	variables ({
		:aet => node[:eja_dicom][:aet],
		:logfile => node[:eja_dicom][:logfile],
		:output_directory => node[:eja_dicom][:output_directory],
		:port => node[:eja_dicom][:port],
		:install_root => node[:eja_dicom][:install_root],
		:install_dirname => node[:eja_dicom][:install_dirname]
		})
	notifies :restart, "service[dicom]", :delayed
end

template "/etc/init.d/dicom" do
	mode 00755
	variables ({
		:logfile => node[:eja_dicom][:logfile],
		:script_location => node[:eja_dicom][:script_location],
		:user => node[:eja_dicom][:user]
		})
	notifies :restart, "service[dicom]", :delayed
end

file node[:eja_dicom][:logfile] do
	owner node[:eja_dicom][:user]
	group node[:eja_dicom][:group]
	mode 0640
end

service "dicom" do
	action [ :enable, :start ]
end
