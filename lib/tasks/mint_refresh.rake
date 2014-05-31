require 'minty'

desc "Force refresh of Mint.com data from banks"
task :mint_refresh do
  mint = Minty::Client.new(Minty::Credentials.new)
  mint.refresh
end
