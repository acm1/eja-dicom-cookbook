default[:eja_dicom][:port] = 10104
default[:eja_dicom][:output_directory] = "/opt/dicom_output"
default[:eja_dicom][:output_directory_mode] = 00750
default[:eja_dicom][:aet] = "eja_dicom"
default[:eja_dicom][:logfile] = "/var/log/eja-dicom.log"
default[:eja_dicom][:install_root] = "/opt"
default[:eja_dicom][:bin_dir] = "/opt/eja-dicom"
default[:eja_dicom][:user] = "dicom"
default[:eja_dicom][:group] = "dicom"
case node["platform"]
when "ubuntu"
  default[:eja_dicom][:pkg_name] = "eja-storescp_362_2014-09-19"
  default[:eja_dicom][:bin_name] = "eja-storescp-ubuntu14"
  default[:eja_dicom][:source] = "http://leviticus.cla.umn.edu/software/eja-dicom/eja-storescp_362_2014-09-19.tar.gz"
  default[:eja_dicom][:install_path] = "/opt/eja-storescp_362_2014-09-19"
  default[:eja_dicom][:service_name] = "dicom"

when "redhat", "centos"
  default[:eja_dicom][:pkg_name] = "eja-dicom-centos7"
  default[:eja_dicom][:bin_name] = "eja-storescp-362-Linux-x86_64"
  default[:eja_dicom][:source] = "http://leviticus.cla.umn.edu/software/eja-dicom/eja-dicom-centos7.tar.gz"
  default[:eja_dicom][:install_path] = "/opt/eja-dicom-centos7"
  default[:eja_dicom][:startup_script] = "/opt/eja-dicom/dicom.sh"
  default[:eja_dicom][:service_name] = "eja-dicom"
end
