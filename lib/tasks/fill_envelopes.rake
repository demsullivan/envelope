require 'sinatra/activerecord'
require './models/envelope'
require './models/transaction'

desc "Re-fill the money envelopes"
task :fill_envelopes do
  Envelope.all.each do |e|
    t = Transaction.new :date => Date.today, :amount => e.weekly_amount, :envelope => e, :bank => "Fill"
    t.save!
    e.update_balance!
  end
end
