require "keppler_watson/version"
require 'net/http'
require 'uri'
require 'byebug'

module KepplerWatson
  # Your code goes here...
  class LanguageTraslator

    def initialize(params)
      @api_key = params[:api_key]
      @version = params[:version]
    end

    def translate(text, model_id="es-en")
      params = { text: text, model_id: model_id }
      api_post(:translate, params)
    end

    def identify(text)
      api_post(:identify, text)
    end

    private

    def api_url
      'https://gateway.watsonplatform.net/language-translator/api/v3'
    end

    def api_post(action, params)
      uri = URI.parse("#{api_url}/#{action.to_s}?version=#{@version}")
      request = Net::HTTP::Post.new(uri)
      if action.eql?(:translate)
        request['Content-Type'] = "application/json"
        request.body = params.to_json
      else
        request['Content-Type'] = "text/plain"
        request.body = params.to_json
      end
      request.basic_auth("apikey", @api_key.to_s)
      req_options = { use_ssl: uri.scheme == "https", }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      JSON.parse(response.body, object_class: OpenStruct)
    end
  end
end
