require "functions_framework"
require "json"
require "pry"

#
# expected event format:
# {
#   "timestamp": 1437522387,
#   "user": "admin@example.com",
#   "sourceIP": "108.50.169.163",
#   "event": {
#     "clusterID": "26b3c8ef50bf96c2",
#     "action": "take",
#     "timestamp": 1437522387 
#   }
# }
# 

def user? email
  email != nil # TODO validate email addr format
end

def timestamp? time
  time != nil
end

def sourceip? ip
  block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
  re = /\A#{block}\.#{block}\.#{block}\.#{block}\z/
  ip != nil && re =~ ip  
end

def clusterid? id
  id != nil && id.length == 16
end

def action? action
  action != nil && (action == "take" || action == "release")
end 

FunctionsFramework.http("event") do |request|
  puts "received event"
  good_event = false
  if request.post?
    event = request.POST
    valid_event = false
    body = JSON.parse(request.body.read) # TODO handle really badly formatted event

    # validate top-level fields
    if not(timestamp?(body["timestamp"]) && sourceip?(body["sourceIP"]) && user?(body["user"]))
      puts "badly formatted message"
      break
    end

    puts body

    # validate event fields
    event = body["event"]
    if (timestamp?(event["timestamp"]) && clusterid?(event["clusterID"]) && action?(event["action"]))
      good_event = true
    else 
      puts "badly formatted event"
    end
  end

  if good_event
    puts "GOOD EVENT processed"
    "OK"
  else
    puts "BAD EVENT processed"
    "BAD_EVENT"
  end
end