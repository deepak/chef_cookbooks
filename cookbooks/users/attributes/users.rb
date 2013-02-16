default['users']['names'] = {
  "deployer" => { password: "$1$MWFOrMMk$PM4rqpN3ac1y1C61Q4lJY.", role: "deploy", sudo: true, admin: true, set_rbenv_version: true },
  "app"      => { password: "$1$MWFOrMMk$PM4rqpN3ac1y1C61Q4lJY.", set_rbenv_version: true }
}

default['users']['ssh_keys'] = {
  "brug"  => "<ssh-key-2> CHANGE IT"
}
