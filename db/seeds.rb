# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'uri'
require 'net/http'
require 'json'

url = URI("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMGY5NTFjZDE4NDQ1MjkyNGM4OWI5Yzg3MDJhYTI1ZCIsInN1YiI6IjY1YzdiMjhkYTMxNDQwMDE4NjhkZjkyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4UxtdGcX756V7uGrXrLAdnc-Pkxh8NNQa3Rwm26avps'

response = http.request(request)
result = JSON.parse(response.read_body)
result["results"].each do |movie_data|
  title = movie_data["title"]
  overview = movie_data["overview"]
  poster_url = "https://image.tmdb.org/t/p/w500#{movie_data["poster_path"]}"
  rating = (movie_data["vote_average"] * 10).to_i
  Movie.create!(title: title, overview: overview, poster_url: poster_url, rating: rating)
end
puts 'Movies seeded successfully!'
