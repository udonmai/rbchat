# Local
# Redis = Redis.new(:host => 'localhost', :port => 6379)

uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
Redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

# Heroku
# Redis = Redis.new(:host => 'redis://redistogo:9dc8f46f1ed6e688b1fbe082d9495ae8@spadefish.redistogo.com', :port => 9070)

