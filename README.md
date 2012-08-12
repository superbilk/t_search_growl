# Prerequisites

You definitely want to sign up at https://dev.twitter.com to get a `consumer_key` and `consumer_secret`. Otherwise you may run into Twitter API limits.

You need a config file named `config.yml`, see template file

You need an `images` folder for twitter profile images

# Usage
```ruby
require './t_search_growl'

t = TSearchGrowl.new
t.search("agile2012")
```

# Options
```ruby
t.loop        # true: if you'd like to get regular updated; false: runs only once (default=true)
t.last_id     # integer: get only tweets AFTER that id (default=reads config file OR 1) 
t.rerun       # integer: seconds to wait befor getting updated (default=10)
t.max         # integer: number of tweets to get with every update (default=25)
t.max_first   # integer: number of tweets to fetch in the first run (default=max)
t.persistent  # true: save last_id to config file; false: don't save (default=true)
```

