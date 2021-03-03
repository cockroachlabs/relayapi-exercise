require "functions_framework"
require "json"
require "pry"

#
# expected event format:
# {
#   "timestamp": 1437522387,
#   "event": {
#     "sourceIP": "108.50.169.163",
#     "clusterID": "26b3c8ef50bf96c2",
#     "action": "take",
#     "timestamp": 1437522387 
#   }
# }
# 

def timestamp? time
  time != nil
end

def sourceip? ip
  ip != nil # TODO regex format
end

def clusterid? id
  id != nil && id.length == 16
end

def action? action
  action != nil && (action == "take" || action == "release")
end 

FunctionsFramework.http("event") do |request|
  good_event = false
  if request.post?
    event = request.POST
    valid_event = false
    body = JSON.parse(request.body.read) # TODO handle really badly formatted event

    puts body
    if body["timestamp"] != nil && body["event"] != nil
      event = body["event"]
      if (timestamp?(event["timestamp"]) && sourceip?(event["sourceIP"]) && clusterid?(event["clusterID"]) && action?(event["action"]))
        good_event = true
      end
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