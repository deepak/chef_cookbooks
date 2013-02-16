name              "timezone"
maintainer        "Deepak Kannan"
maintainer_email  "kannan.deepak@gmail.com"
license           "Apache 2.0"

description       "Configure the system timezone on Debian or Ubuntu."
version           "0.0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end
