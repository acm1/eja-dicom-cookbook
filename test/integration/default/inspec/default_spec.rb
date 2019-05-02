if os.family == 'debian'
  describe package('libwrap0:amd64') do
    it { should be_installed }
  end

  describe package('libicu52') do
    it { should be_installed }
  end

  describe file('/opt/eja-storescp_362_2014-09-19') do
    it { should be_directory }
  end

  describe file('/opt/eja-dicom/eja-storescp-ubuntu14') do
    it { should exist }
  end

  describe file('/etc/init.d/dicom') do
    it { should exist }
    its('content') { should match(%r{BIN_NAME="eja-storescp-ubuntu14"}) }
    its('content') { should match(%r{OUTPUT_DIR="/opt/dicom_storage"}) }
  end

elsif os.family == 'redhat'
  describe file('/opt/eja-dicom-centos7') do
    it { should be_directory }
  end

  describe file('/opt/eja-dicom/eja-storescp-362-Linux-x86_64') do
    it { should exist }
  end

  describe file('/opt/eja-dicom/dicom.sh') do
    it { should exist }
	its('content') { should match(%r{\./eja-dicom -pm -aet dicombliss -od /opt/dicom_storage -sa -lf /var/log/eja-dicom\.log \+xa 10104 &}) }
  end

  describe file('/etc/systemd/system/eja-dicom.service') do
    it { should exist }
    its('content') { should match(%r{ExecStart=/opt/eja-dicom/dicom.sh}) }
  end

end

describe file('/opt/dicom_storage') do
  it { should be_directory }
  its('group') { should eq '_dicom'}
  its('mode') { should cmp '02775' }
end

describe file('/opt/eja-dicom') do
  it { should be_symlink }
end
