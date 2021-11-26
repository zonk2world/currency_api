# frozen_string_literal: true

#################################################################
#
# File: lib/api.rb
#
#################################################################

require 'net/http'
require 'json'

$: << File.join(File.dirname(__FILE__), '../models')
require 'project_model'

# API routes and methods
class Api
  def self.routes
    [
      { method: 'GET', path: %r{^/api/projects/(?<id>\d+)}, api_method: :find },
      { method: 'POST', path: %r{^/api/projects}, api_method: :create },
      { method: 'PUT', path: %r{^/api/projects/(?<id>\d+)}, api_method: :update, auth_required: true },
      { method: 'POST', path: %r{^/api/convert_currency}, api_method: :convert_currency, auth_required: true }
    ]
  end

  def self.find(params)
    # "GET find"
    Project.find params
  end

  def self.create(params)
    # "POST create"
    validate params, :title
    Project.create params
  end

  def self.update(params)
    # "PUT update"
    action = params[:action]
    if action == 'rotate_apikey'
      Project.update_apikey params
    else
      Project.update params
    end
  end

  def self.convert_currency(params)
    # "POST convert_currency"
    authorize_conversion params

    # TODO: the fixer url should be in env
    uri = URI("https://data.fixer.io/api/convert?access_key=1fc3b39b5a728152b6462454f7361665&from=#{params[:from]}&to=#{params[:to]}&amount=#{params[:amount]}")
    conversion_data = Net::HTTP.get(uri)

    JSON.parse(conversion_data)
  end

  def self.validate(params, key)
    raise Exception, "#{key} is empty" if params[key].nil?
  end

  def self.authorize_conversion(params)
    raise Exception, 'Unauthorized' unless Project.find_by(params, :api_key)
  end

end
