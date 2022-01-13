require 'sinatra'
require 'sinatra/url_for'
require 'haml'
require 'securerandom'

require 'sinatra/reloader' if development?

# set :bind and :port settings from ENV vars
# TUNA_FAIL_BIND and TUNA_FAIL_PORT
['bind', 'port'].each do |config|
  env_key = 'TUNA_FAIL_' + config.upcase
  default = settings.send(config)
  set config, ENV[env_key] || default
end

set :haml, :format => :html5

endpoints = Hash.new do |hash, key| 
  hash[key]= {rc: 200, mbody: 'Success', flap: 0}
end

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
  pct = params['flap'].to_i < 0 ? 0 : params['flap'].to_i
  pct = params['flap'].to_i > 100 ? 100 : pct
  endpoints[key][:flap] = pct
  redirect url_for "/endpoints/#{e}/manage"
end

def flap(pct)
  pct /= 100.0
  rand <= pct ? [500, "flapping"] : false
end

get '/endpoints/:e/target' do
  e = endpoints[params['e'].to_sym]
  flap(e[:flap]) || e.values_at(:rc, :mbody)
end
