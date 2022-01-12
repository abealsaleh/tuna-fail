require 'sinatra'
require 'sinatra/url_for'
require 'haml'
require 'securerandom'

require 'sinatra/reloader' if development?

set :haml, :format => :html5

endpoints = Hash.new do |hash, key| 
  hash[key]= {rc: 200, mbody: 'Success', flap: false}
end

endpoints[:foo] # testing data

get '/' do
  haml :index, :locals => { :endpoints => endpoints }
end

post '/endpoint/new' do
  name = SecureRandom.hex
  endpoints[name.to_sym]
  redirect url_for "/endpoints/#{name}/manage"
end

get '/endpoints/:e/manage' do
  haml :endpoint, :locals => { name: params['e'],
    values: endpoints[params['e'].to_sym],
    target: url_for("/endpoints/#{params['e']}/target", :full)
  }
end

post '/endpoints/:e/manage' do
  e = params['e']
  key = e.to_sym
  endpoints[key][:rc] = params['rc'].to_i
  endpoints[key][:mbody] = params['mbody']
  if params["flap"] == "on"
    endpoints[key][:flap] = true
  else
    endpoints[key][:flap] = false
  end
  redirect url_for "/endpoints/#{e}/manage"
end

def flap
  rand < 0.5 ? [500, "flapping"] : false
end

get '/endpoints/:e/target' do
  e = params['e'].to_sym
  if endpoints[e][:flap]
    flap || endpoints[e].values_at(:rc, :mbody)
  else
    endpoints[e].values_at(:rc, :mbody)
  end
end
