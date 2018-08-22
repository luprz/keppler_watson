require "keppler_watson/version"
require 'net/http'
require 'uri'
require 'byebug'

module KepplerWatson
  # Your code goes here...
  class VisualRecognition

    def initialize(params)
      @api_key = params[:api_key]
      @version = params[:version]
      @lang = params[:lang]
    end

    def classify_image(image_url, classifier_ids='default')
      api_request(:get, :classify, params(image_url, classifier_ids))
    end

    def classify_images(images_url, classifier_ids='default')
      api_request(:post, :classify, params_images(images_url, classifier_ids))
    end

    def detect_face(images_url)
      api_request(:get, :detect_faces, params_face(images_url))
    end

    private

    def api_url
      'https://gateway.watsonplatform.net/visual-recognition/api/v3'
    end

    def params(image_url, classifier_ids='default')
      "url=#{image_url}&classifier_ids=#{classifier_ids}&version=#{@version}"
    end

    def params_face(image_url)
      "url=#{image_url}&version=#{@version}"
    end

    def params_images(images_url, classifier_ids='default')
      "images_file=#{images_url}&classifier_ids=#{classifier_ids}&version=#{@version}"
    end

    def method_detect(method)
      if method.eql?(:get)
        Net::HTTP::Get
      elsif method.eql?(:post)
        Net::HTTP::Post
      end
    end

    def api_request(method, action, params)
      uri = URI.parse("#{api_url}/#{action.to_s}?#{params}")
      request = method_detect(method).new(uri)
      request['Accept-Language'] = @lang
      request.basic_auth("apikey", @api_key.to_s)
      req_options = { use_ssl: uri.scheme == "https", }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      JSON.parse(response.body, object_class: OpenStruct)
    end
  end
end
