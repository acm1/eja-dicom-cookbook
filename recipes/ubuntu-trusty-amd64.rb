#
# Cookbook Name:: eja_dicom
# Recipe:: ubuntu-trusty-amd64
#
# Copyright (C) 2015 Judy Kallestad, (C) Regents of the University of Minnesota
# 
# Install required libraries to make eja-dicom work on Ubuntu Trusty (14.04) 64-bit

package "libc6-i386"
package "libstdc++6:i386"
package "libssl1.0.0:i386"
package "libwrap0:i386"
package "lib32z1"
package "libicu52"

link "/usr/lib/libssl.so.6" do
	to "/lib/i386-linux-gnu/libssl.so.1.0.0"
end

link "/usr/lib/libcrypto.so.6" do
	to "/lib/i386-linux-gnu/libcrypto.so.1.0.0"
end
