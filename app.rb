require "sinatra"
require "redis"
require "securerandom"
require "json"

REDIS = Redis.new

post "/characters" do
  id = SecureRandom.uuid
  data = JSON.parse(request.body.read)
  puts data
  REDIS.set "id:#{id}", {
    name: data["name"],
    description: data["description"],
  }.to_json
  puts "Created #{id}"

  content_type :json
  { id: id }.to_json
end

get "/characters" do
  keys = REDIS.keys "id:*"
  puts "Retrieved #{keys.length} keys"

  content_type :json
  keys.map { |key| JSON.parse(REDIS.get(key)).merge(id: key) }.to_json
end

get "/characters/:id" do
  id = params["id"]
  data = REDIS.get "id:#{id}"
  puts "Retrieved #{id}"

  content_type :json
  data
end
