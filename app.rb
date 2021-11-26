# frozen_string_literal: true

#################################################################
#
# File: app.rb
#
#################################################################

require 'rubygems'
require 'bundler/setup'

require 'rack'
require 'json'
require 'sqlite3'

$: << File.dirname(__FILE__)
require 'router'

app = -> environment {
  request = Rack::Request.new(environment)

  request_headers = Hash[
    *environment.select { |k, _| k.start_with? 'HTTP_' }
      .collect { |k, v| [k.sub(/^HTTP_/, ''), v] }
      .collect { |k, v| [k.split('_').collect(&:downcase).join('_'), v] }
      .sort
      .flatten
    ]

  if route_match = Router.find_match(request.request_method, request.path, Api.routes)
    begin
      if route_match[:auth_required] && request_headers['x_api_key'].nil?
        raise Exception, 'Unauthorized'
      end

      api_params = request.params.merge(
        route_match[:params],
        'api_key' => request_headers['x_api_key']
      ).transform_keys(&:to_sym)
      response_data = Api.send(route_match[:api_method], api_params)

      [200, { 'Content-Type' => 'application/json' }, StringIO.new(response_data.to_json)]

    rescue Exception => e
      [401, { 'Content-Type' => 'text/plain' }, StringIO.new(e.message)]
    rescue SQLite3::Exception => e
      [422, { 'Content-Type' => 'text/plain' }, StringIO.new(e.message)]
    end
  else
    [404, { 'Content-Type' => 'text/plain' }, StringIO.new('Not found')]
  end
}

Rack::Handler::WEBrick.run(app, :Port => 3000, :Verbose => true)
