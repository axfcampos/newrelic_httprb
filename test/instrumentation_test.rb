require "http"
require "test/unit"
require "newrelic_rpm"
require "newrelic/httprb"

class HTTPTest < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  URL = "http://www.google.com/index.html"

  def setup
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats
  end

  def assert_metrics(*m)
    m.each do |x|
      assert @engine.get_stats_no_scope(x), "#{x} not in metrics"
    end
  end

  def test_get
    response = HTTP.get URL

    assert_match /<head>/i, response.body
    assert_metrics "External/all",
                   "External/www.google.com/http.rb/GET",
                   "External/allOther",
                   "External/www.google.com/all"
  end

  def test_post
    HTTP.post URL

    assert_metrics "External/all",
                   "External/www.google.com/http.rb/POST",
                   "External/allOther",
                   "External/www.google.com/all"
  end

  def test_ignore
    NewRelic::Agent.disable_all_tracing do
      HTTP.get URL
    end

    assert_empty @engine.to_h
  end
end
