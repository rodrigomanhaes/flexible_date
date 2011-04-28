require File.join(File.dirname(__FILE__), 'spec_helper')

class Event < ActiveRecord::Base
  flexible_date :start_date, :end_date, :format => "%d/%m/%Y"
end

describe 'flexible date' do
  it 'generates a property with suffix _flex' do
    event = Event.new
    event.should respond_to(:start_date_flex)
    event.should respond_to(:start_date_flex=)
    event.should respond_to(:end_date_flex)
    event.should respond_to(:end_date_flex=)
  end
end

