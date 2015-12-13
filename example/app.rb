require 'sinatra'

def person
  { name: 'Mike', id: 1, occupation: 'Developer', gender: 'Male' }
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
