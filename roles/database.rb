name "database"
description "A box having a database server, client and development headers"

run_list [ 
          "role[basebox]",
          "recipe[postgres]"
         ]
