require 'sinatra/activerecord'
require './models/envelope'
require './models/transaction'
require 'minty'

desc "Sync transaction data from Mint"
task :mint_sync do
  mint = Minty::Client.new(Minty::Credentials.new)


  last_fill_date = Transaction.last_fill.date
  puts "grabbing transactions since #{last_fill_date}"
    
  envelopes = Envelope.grouped_by_category
  other_envelope = Envelope.where(:name => "Unplanned").first
  txns = mint.transactions :startDate => last_fill_date, :endDate => last_fill_date+7

  txns.each do |txn|
    envelope = envelopes[txn.category].nil? ? other_envelope : envelopes[txn.category]

    if not envelope.nil? and not txn.pending?
      amount = txn.debit? ? txn.amount.delete('$').to_f * -1 : txn.amount.delete('$').to_f
      params = {:bank => txn.bank, :account => txn.account, :date => txn.date,
        :category => txn.category, :merchant => txn.description, :amount => amount,
        :envelope => envelope, :mint_id => txn['id']}

      db_txn = Transaction.where(:mint_id => txn.id).first

      # create a new transaction if one doesn't exist
      Transaction.create(params) if db_txn.nil? and not Envelope::REGULAR_EXPENSES.include? txn.category

      # delete the transaction if it exists and the category is now an ignored category
      if not db_txn.nil?
        if Envelope::REGULAR_EXPENSES.include? txn.category
          db_txn.delete
        else
          db_txn.update_attributes(params)
        end
      end
    end
  end

  envelopes.values.each {|e| e.update_balance! }
  other_envelope.update_balance!
end
