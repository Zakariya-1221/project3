require 'dotenv/load'
require 'httparty'
require 'json'

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
      #puts "Raw Assignments Data: #{assignments.inspect}" # Debugging output
      return assignments
    else
      puts "Failed to retrieve data: #{response.code}"
      []
    end
  end
  
  # Get courses and display upcoming assignments
  def display_upcoming_assignments
    courses = get_courses
    courses.each do |course|
      puts "Course: #{course['name']}"
      assignments = get_upcoming_assignments(course['id'])
  
      if assignments.empty?
        puts "No upcoming assignments.\n\n"
      else
        assignments.each do |assignment|
          puts "Assignment: #{assignment['name']}"
          puts "Due Date: #{assignment['due_at']}"
          puts "URL: #{assignment['html_url']}"
          puts "-------------------------"
        end
      end
    end
  end


#Test the function
display_upcoming_assignments