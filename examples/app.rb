require 'sinatra'

def person
  { name: 'Mike', id: 1, occupation: 'Developer', gender: 'Male' }
end

def place
  { name: 'Vancouver', id: 1, weather: 'Rainy' }
end

get '/people' do
  [person].to_json
end

get '/people/:id' do
  person.to_json
end

post '/people' do
  person.to_json
end

get '/places' do
  [place].to_json
end

get '/places/:id' do
  place.to_json
end

post '/places' do
  place.to_json
end
