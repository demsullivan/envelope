class Transaction < ActiveRecord::Base
  belongs_to :envelope

  def self.last_fill
    where(:bank => "Fill").order("date DESC")[0]
  end

  def self.default_scope
    where("date >= :last_fill", :last_fill => last_fill.date).order("date ASC")
  end

end
