require './models/envelope'

if Envelope.count == 0
  envelopes = [
               {:name => "Groceries", :weekly_amount => 150.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Groceries"},
               {:name => "Gas", :weekly_amount => 40.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Gas & Fuel"},
               {:name => "TTC", :weekly_amount => 31.5, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Public Transportation"},
               {:name => "Laundry", :weekly_amount => 20.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Laundry"},
               {:name => "Dining Out", :weekly_amount => 34.5, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Fast Food,Restaurants"},
               {:name => "Angie", :weekly_amount => 40.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Angie Cash"},
               {:name => "Erica", :weekly_amount => 20.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Erica Allowance"},
               {:name => "Josh", :weekly_amount => 20.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => "Josh Allowance"},
               {:name => "Unplanned", :weekly_amount => 0.0, :balance => 0.0, :last_txn_id => 0, :mint_categories => ""}]

  envelopes.each do |e|
    envelope = Envelope.create(e)
    puts "Created envelope #{envelope[:name]}."
  end
end

if Transaction.count == 0
  Envelope.all.each do |e|
    e.fill "2014/05/23"
    e.update_balance!
  end
end
