require "keppler_watson/version"
require 'net/http'
require 'uri'
require 'byebug'

module KepplerWatson
  # Your code goes here...
  class PersonalityInsights

    def initialize(params)
      @username = params[:username]
      @password = params[:password]
      @version = params[:version]
      @lang = params[:lang]
    end

    def profile(params)
      api_post(:profile, params)
    end

    private

    def api_url
      'https://gateway.watsonplatform.net/personality-insights/api/v3'
    end

    def api_post(action, params)
      uri = URI.parse("#{api_url}/#{action.to_s}?version=#{@version}&consumption_preferences=true&raw_scores=true")
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = "application/json"
      request['Accept'] = "application/json"
      request['Accept-Language'] = @lang
      request.basic_auth(@username.to_s, @password.to_s)
      request.body = params.to_json
      req_options = { use_ssl: uri.scheme == "https", }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      JSON.parse(response.body, object_class: OpenStruct)
    end
  end
end
