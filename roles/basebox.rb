name "basebox"
description "A basic box with some packages, ruby and rbenv installed"

override_attributes({ "rbenv" => {
                        "group_users" => ["deployer"]
                      },
                      "new_relic" => {"license_key" => "<some-key> CHANGE IT"}
                    })

run_list [
          "recipe[timezone]",
          "recipe[locale]",
          "recipe[packages]",
          "recipe[users]",
          "recipe[node]",
          "recipe[ruby]",
          "recipe[newrelic-sysmond]"
         ]
