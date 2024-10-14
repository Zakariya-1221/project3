require 'sinatra'
require 'json'

# Disable Sinatra's error handling
set :show_exceptions, true
# Sample data (could come from a database)
DATA = [
  { id: 1, name: "Alice", age: 30 },
  { id: 2, name: "Bob", age: 25 },
  { id: 3, name: "Charlie", age: 35 }
]

# Define a route to fetch the data
get '/gradedata' do
  content_type :json
  DATA.to_json
end

# Serve the main HTML page for the GUI
get '/' do
  erb :index
end

# Serve the grades HTML page for the GUI
get '/grades' do
  erb :grades
end

