class Event < ActiveRecord::Base
  attr_accessible :end_date, :judgement_day, :payday, :start_date, :description,
    :created_at

  flexible_date :start_date, :end_date, :created_at
  flexible_date :judgement_day, :suffix => 'yyz'
  flexible_date :payday, :if => Proc.new { |n| n.description.blank? }
end
