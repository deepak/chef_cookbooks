http://wiki.opscode.com/display/chef/Data+Bags  
http://wiki.opscode.com/display/chef/Attributes  

The data_bags folder is of the form:  

```text
data_bag/
└── passwords
    └── user.json
└── <BAG-NAME>
    └── <ITEM-NAME>.json
```

#### Format

```javascript
{  
  "id": "item_name",  
  "root": {  
    "password_hashed": "change-the-password"  
  }  
}  
```

See http://tickets.opscode.com/browse/CHEF-3149  
every DataBag needs an id which is the filename.  

In the cookbooks the DataBag can be accessed by:  

user_passwords = data_bag_item 'passwords', 'user'  
user_passwords["root"]["password_hashed"]  

Notice that the keys have to be strings not symbols. This is because   
data_bag_items behaves like a Hash not a Chef's Mash
