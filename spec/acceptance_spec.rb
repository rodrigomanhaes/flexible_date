require 'spec_helper'

feature 'flexible date' do
  scenario 'converts dates from specified format' do
    visit new_event_path
    fill_in 'Start date', with: '20-01-2012'
    fill_in 'End date', with: '29-02-2012'
    fill_in 'Judgement day', with: '20-12-2012'
    fill_in 'Payday', with: '31-01-2012'
    click_button 'Save'

    page.should have_content 'Start date: 20-01-2012'
    page.should have_content 'End date: 29-02-2012'
    page.should have_content 'Judgement day: 20-12-2012'
    page.should have_content 'Payday: 31-01-2012'

    event = Event.last
    event.start_date.should == Date.new(2012, 1, 20)
    event.end_date.should == Date.new(2012, 2, 29)
    event.judgement_day.should == Date.new(2012, 12, 20)
    event.payday.should == Date.new(2012, 1, 31)
  end
end
