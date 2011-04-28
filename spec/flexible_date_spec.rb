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

  it 'converts formatted inputs to respective fields' do
    event = Event.new
    event.start_date_flex = "31/01/2011"
    event.end_date_flex =  "28/02/2011"
    event.start_date.should == Date.new(2011, 01, 31)
    event.end_date.should == Date.new(2011, 02, 28)
  end

  it 'returns dates formatted as configured' do
    event = Event.new :start_date => '2011-01-31',
                      :end_date => Date.new(2011, 02, 28)
    event.start_date_flex.should == "31/01/2011"
    event.end_date_flex.should == "28/02/2011"
  end
end

