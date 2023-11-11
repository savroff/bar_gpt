require "sinatra"
require "redis"
require "securerandom"
require "json"

REDIS = Redis.new

post "/create" do
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
