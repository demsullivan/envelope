class CreateEnvelopes < ActiveRecord::Migration
  def change
    create_table :envelopes do |t|
      t.string :name
      t.float :weekly_amount
      t.float :balance
      t.integer :last_txn_id
      t.string :mint_categories
    end
  end
end
