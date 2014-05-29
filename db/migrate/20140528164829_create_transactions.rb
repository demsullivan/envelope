class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string     :bank
      t.string     :account
      t.date       :date
      t.string     :category
      t.string     :merchant
      t.float      :amount
      t.integer    :mint_id
      t.references :envelope
    end
  end
end
