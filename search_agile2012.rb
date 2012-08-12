require './t_search_growl'

t = TSearchGrowl.new
t.loop = false
t.max_first = 3
t.search("agile2012")
