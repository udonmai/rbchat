# Local
#Redis = Redis.new(:host => 'localhost', :port => 6379)

# Heroku
Redis = Redis.new(:host => 'redis://redistogo:9dc8f46f1ed6e688b1fbe082d9495ae8@spadefish.redistogo.com', :port => 9070)

