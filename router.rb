# frozen_string_literal: true

#################################################################
#
# File: router.rb
#
#################################################################

$: << File.join(File.dirname(__FILE__), 'lib')
require 'api'

# Simplistic router based on path and request method
class Router
  def self.find_match(request_method, path, routes)
    # find matched route
    routes.each do |route|
      if match = match_route(request_method, path, route)
        return match
      end
    end
    nil
  end

  def self.match_route(request_method, path, route)
    if route[:method] == request_method && match_data = route[:path].match(path)
      route_match = route.slice(:api_method, :auth_required)

      if match_data.names
        route_match[:params] = match_data.names.inject({}) do |params, name|
          params[name] = match_data[name]
          params
        end
      else
        route_match[:params] = {}
      end
      route_match
    else
      nil
    end
  end
end
