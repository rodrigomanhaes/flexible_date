class Event < ActiveRecord::Base
  attr_accessible :end_date, :judgement_day, :payday, :start_date, :description

  flexible_date :start_date, :end_date
  flexible_date :judgement_day, :suffix => 'yyz'
  flexible_date :payday, :if => Proc.new { |n| n.description.blank? }
end
