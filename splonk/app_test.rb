require "minitest/autorun"
require "functions_framework/testing"

class SplonkTest < Minitest::Test
  include FunctionsFramework::Testing

  def test_good_event
    load_temporary "app.rb" do
      message = <<~HEREDOC
      {
        "timestamp": 1437522387,
        "user": "admin@example.com",
        "sourceIP": "108.50.169.163",
        "event": {
          "clusterID": "26b3c8ef50bf96c2",
          "action": "take",
          "timestamp": 1437522387 
        }
      }      
      HEREDOC
      request = make_post_request "https://example.com/foo", message,
                                  ["Content-Type: application/json"]
      response = call_http "event", request
      assert_equal 200, response.status
      assert_equal "OK", response.body.join
    end
  end

  def test_bad_event_missing_timestamp
    message = <<~HEREDOC
    {
      "user": "admin@example.com",
      "sourceIP": "108.50.169.163",
      "event": {
        "clusterID": "26b3c8ef50bf96c2",
        "action": "take",
        "timestamp": 1437522387 
      }
    }      
    HEREDOC

    load_temporary "app.rb" do
      request = make_post_request "https://example.com/foo", message,
                                  ["Content-Type: application/json"]
      response = call_http "event", request
      assert_equal 400, response.status
      assert_equal "BAD_EVENT", response.body.join
    end
  end

  def test_bad_event_missing_action
    message = <<~HEREDOC
    {
      "timestamp": 1437522387,
      "user": "admin@example.com",
      "sourceIP": "108.50.169.163",
      "event": {
        "clusterID": "26b3c8ef50bf96c2",
        "timestamp": 1437522387 
      }
    }      
    HEREDOC

    load_temporary "app.rb" do
      request = make_post_request "https://example.com/foo", message,
                                  ["Content-Type: application/json"]
      response = call_http "event", request
      assert_equal 400, response.status
      assert_equal "BAD_EVENT", response.body.join
    end
  end
end