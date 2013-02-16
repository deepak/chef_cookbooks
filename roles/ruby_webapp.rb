name "ruby_webapp"
description "A box which can host ruby webapps including rails"

override_attributes "rails" => {
  "apps" => ["acme-webapp"]
}

run_list [ 
          "role[basebox]",
          "recipe[bundler]",
          "recipe[rails]"
         ]
