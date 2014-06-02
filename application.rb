require 'bundler/setup'
Bundler.require :default
require 'sinatra/base'

Dir[File.expand_path('./lib/*.rb')].each {|f| require f }
Dir[File.expand_path('./models/*.rb')].each {|f| require f }

# %w(lib models).each do |dir|
#   Dir[File.expand_path('./#{dir}/*.rb')].each {|f| require f }
# end

class Website < Sinatra::Base
  root_dir = File.dirname(__FILE__)

  register Sinatra::ActiveRecordExtension
  register Sinatra::Bootstrap::Assets

  set :environment, ENV['RACK_ENV'] || :development
  set :root, root_dir
  set :app_file, __FILE__
  set :static, true

  use Rack::Auth::Basic, "Envelope" do |user, pass|
    user == 'admin' and pass == ENV['LOGIN_PASSWD']
  end

  helpers do
    include Helpers
  end

  before do
    # @var = blah
  end

  get '/application.css' do
    sass :application
  end

  get '/application.js' do
    coffee :application
  end

  get '/' do
    @envelopes = Envelope.order('id ASC').all
    if request['refresh']
      load 'Rakefile'
      Rake::Task["mint_sync"].invoke
    end
    haml :home
  end

  get '/envelope/:id' do |id|
    @envelope = Envelope.find id
    haml :envelope
  end

end
