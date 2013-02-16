include_recipe "apt"
include_recipe 'git'

# clock can drift without NTP
include_recipe "ntp"

# useful for moving stuff
package "rsync"
package "curl"

# suggested by apt-get install git also "rvm requirements"
# useful for applying patches to ruby src
package "patch"

package "finger"
package "mtr"

package "tree"

# Shows the members of a group; by default
package "members"

# almost-definately will be already installed
package "bash"
package "tar"
package "grep"
package "less"
package "ssl-cert"
# always installed on ubuntu
# package "sudo"

package "vim"
# package "emacs"

# package "openssh-server", "openssh-client"
# https://github.com/opscode-cookbooks/openssh/
# include_recipe 'openssh'

# for automated installs of debs
package "debconf-utils"

include_recipe 'packages::scripts'
