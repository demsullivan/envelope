require 'sinatra/activerecord'
require './models/envelope'
require './models/transaction'
require './lib/credentials'
require './lib/mint'

desc "Sync transaction data from Mint"
task :mint_sync do
  credentials = Credentials.new
  credentials.validate!

  mint = Mint.new credentials
  mint.authenticate

  last_fill_date = Transaction.last_fill.date
  puts "grabbing transactions since #{last_fill_date}"
    
  envelopes = Envelope.grouped_by_category
  other_envelope = Envelope.where(:name => "Unplanned")[0]
  txns = mint.transactions :startDate => last_fill_date, :endDate => last_fill_date+7

  txns.each do |txn|
    if Envelope::REGULAR_EXPENSES.include? txn['category']
      next
    end

    puts txn['date']
    envelope = envelopes[txn['category']].nil? ? other_envelope : envelopes[txn['category']]

    if not envelope.nil? and not txn['isPending']
      txn['date'] = Date.strptime txn['date'], "%b %d"
      puts txn['date']
      amount = txn['isDebit'] ? txn['amount'].delete('$').to_f * -1 : txn['amount'].delete('$').to_f
      params = {:bank => txn['fi'], :account => txn['account'], :date => txn['date'],
        :category => txn['category'], :merchant => txn['merchant'], :amount => amount,
        :envelope => envelope, :mint_id => txn['id']}

      db_txn = Transaction.where(:mint_id => txn['id']).first
      Transaction.create(params) if db_txn.nil?
      db_txn.update_attributes(params) if not db_txn.nil?

    end
  end

  envelopes.values.each {|e| e.update_balance! }
  other_envelope.update_balance!
end