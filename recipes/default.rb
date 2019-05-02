#
# Cookbook Name:: eja_dicom
# Recipe:: default
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
#

# Apt needs to be updated when running under test kitchen in order to
# install packages.
if Chef::Config[:solo] && platform?("ubuntu")
  execute "apt-get update"
end

return if platform?("ubuntu") && node["platform_version"].to_f < 12.04

# Install required libraries
case node["platform"]
when "ubuntu"
  case node["platform_version"].to_f
  when 14.04
    include_recipe "#{cookbook_name}::ubuntu-trusty-amd64"
  end

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

directory node[:eja_dicom][:install_path] do
  owner node[:eja_dicom][:user]
  group node[:eja_dicom][:group]
  mode '0755'
  action :create
end

remote_file "/tmp/#{node[:eja_dicom][:pkg_name]}.tar.gz" do
  source node[:eja_dicom][:source]
  owner node[:eja_dicom][:user]
  group node[:eja_dicom][:group]
  action :create
  mode '0644'
  notifies :run, "execute[extract_source]"
  not_if { File.exists?("#{node[:eja_dicom][:install_path]}/#{node[:eja_dicom][:bin_name]}") }
end

execute "extract_source" do
  command "tar -xf /tmp/#{node[:eja_dicom][:pkg_name]}.tar.gz -C #{node[:eja_dicom][:install_path]} --strip 1" 
  not_if { File.exists?("#{node[:eja_dicom][:install_path]}/#{node[:eja_dicom][:bin_name]}") }
end

link '/opt/eja-dicom' do
  to node[:eja_dicom][:install_path]
end

# Set up init script for Ubuntu or service script for RHEL
case node["platform"]
when "ubuntu"
  case node["platform_version"].to_f
  when 14.04 
    template "/etc/init.d/dicom" do
   	  source "dicom.erb"
   	  mode "0755"
   	  variables({
   	    :bin_dir => node[:eja_dicom][:bin_dir],
   	    :bin_name => node[:eja_dicom][:bin_name],
   	    :aet => node[:eja_dicom][:aet],
   	    :output_directory => node[:eja_dicom][:output_directory],
   	    :port => node[:eja_dicom][:port],
   	    :logfile => node[:eja_dicom][:logfile],
   	  })
   	  notifies :restart, "service[#{node[:eja_dicom][:service_name]}]", :delayed
    end
  end

when "redhat", "centos"
  case node["platform_version"].to_i
  when 7
    template "#{node[:eja_dicom][:startup_script]}" do
      source "rhel7-dicom.sh.erb"
      mode "0755"
      variables({
        :bin_dir => node[:eja_dicom][:bin_dir],
        :aet => node[:eja_dicom][:aet],
        :output_directory => node[:eja_dicom][:output_directory],
        :port => node[:eja_dicom][:port],
        :logfile => node[:eja_dicom][:logfile],
      })
      notifies :restart, "service[#{node[:eja_dicom][:service_name]}]", :delayed
    end

    template "/etc/systemd/system/eja-dicom.service" do
      source "rhel7-eja-dicom.service.erb"
      mode "0755"
      variables({
        :startup_script => node[:eja_dicom][:startup_script]
      })		   
      notifies :restart, "service[#{node[:eja_dicom][:service_name]}]", :delayed
    end
  end

end
  

file node[:eja_dicom][:logfile] do
  owner node[:eja_dicom][:user]
  group node[:eja_dicom][:group]
  mode 0640
end

service "#{node[:eja_dicom][:service_name]}" do
  action [ :enable, :start ]
end
