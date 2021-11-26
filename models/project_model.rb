# frozen_string_literal: true

#################################################################
#
# File: models/project_model.rb
#
#################################################################

require 'sqlite3'
require 'securerandom'

# Project Model
class Project
  @database = SQLite3::Database.open('currency_conversion.db', results_as_hash: true)

  # project id should not be iterable
  @database.execute 'CREATE TABLE IF NOT EXISTS projects(id TEXT PRIMARY KEY, title TEXT, description TEXT, api_key TEXT)'

  def self.find(params)
    # Query to find a row by id
    query = 'SELECT title, description FROM projects WHERE id = ?'
    @database.get_first_row query, [params[:id]]
  end

  def self.find_by(params, name)
    # Query to find a row by id
    query = "SELECT title, description FROM projects WHERE #{name} = ?"
    @database.get_first_row query, [params[name]]
  end

  def self.create(params)
    # Query to add new row
    api_key = SecureRandom.hex
    query = 'INSERT INTO projects VALUES (?, ?, ?, ?)'
    @database.execute query, [api_key, params[:title], params[:description], api_key]
  end

  def self.update(params)
    # Query to update existing row
    query = 'UPDATE projects SET ? WHERE api_key = ?'

    params_joined = params.slice(:title, :description).map { |k, v| "#{k} = #{v}" }.join(',')
    @database.execute query, [params_joined, params[:api_key]]
  end

  def self.update_apikey(params)
    # Query to update existing row
    new_api_key = SecureRandom.hex
    query = 'UPDATE projects SET api_key = ? WHERE api_key = ?'
    @database.execute(query, [new_api_key, params[:api_key]])
  end
end
