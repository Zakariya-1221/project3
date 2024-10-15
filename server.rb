require 'sinatra'
require 'dotenv/load'
require 'httparty'
require 'json'
require 'sinatra/cross_origin'

# Enable cross-origin requests
configure do
  enable :cross_origin
end

# Allow preflight requests (OPTIONS)
options "*" do
  response.headers["Allow"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  200
end

# Set Access-Control-Allow-Origin header for all responses
before do
    response.headers["Access-Control-Allow-Origin"] = "*"
end

# Load your access token from an environment variable
ACCESS_TOKEN = ENV['CANVAS_ACCESS_TOKEN']
BASE_URL = "https://osu.instructure.com/api/v1"

# Fetch courses to identify course_id
def get_courses
  puts "Using Access Token: #{ACCESS_TOKEN}"  # Debugging line
  response = HTTParty.get("#{BASE_URL}/courses", headers: { "Authorization" => "Bearer #{ACCESS_TOKEN}" })
  if response.code == 200
    JSON.parse(response.body)
  else
    puts 'Courses'
    puts "Failed to retrieve data: #{response.code}"
    []
  end
end

# Fetch upcoming assignments for a specific course
def get_upcoming_assignments(course_id)
  response = HTTParty.get("#{BASE_URL}/courses/#{course_id}/assignments?bucket=upcoming", headers: { "Authorization" => "Bearer #{ACCESS_TOKEN}" })
  if response.code == 200
    assignments = JSON.parse(response.body)
    return assignments
  else
    puts "Failed to retrieve data: #{response.code}"
    []
  end
end

# Route to serve the assignments data
get '/assignments' do
  content_type :json
  courses = get_courses
  courses_with_assignments = courses.map do |course|
    {
      name: course['name'],
      assignments: get_upcoming_assignments(course['id'])
    }
  end
  courses_with_assignments.to_json
end

get '/weekly' do
  erb :weeklyView
end


# Start the Sinatra application
set :port, 4567  # Change this to your preferred port
