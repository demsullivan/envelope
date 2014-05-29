class Envelope < ActiveRecord::Base
  has_many :transactions

  REGULAR_EXPENSES = ["Rent & Mortgage", "PC Mastercard", "CIBC VISA", "Auto Payment", "Loans",
                      "Credit Card Payment", "Internet", "Paycheque", "Transfer", "Movies & DVDs",
                      "Mobile Phone", "Auto Insurance", "Home Insurance", "Hide from Budgets & Trends",
                      "Credit Card interest", "Finance Charge", "Business Services", "Interest Income"]

  def self.grouped_by_category
    grouped = {}
    all.each do |envelope|
      envelope.mint_categories.split(',').each {|c| grouped[c] = envelope }
    end
    grouped
  end

  def update_balance
    self.balance = transactions.sum('amount')
  end

  def update_balance!
    update_balance
    save!
  end
end
