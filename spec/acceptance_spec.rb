require 'spec_helper'

feature 'flexible date on rails' do
  before :each  do
    @start_date = { object: Date.new(2012, 1, 20), string: '20-01-2012' }
    @end_date = { object: Date.new(2012, 2, 29), string: '29-02-2012' }
    @judgement_day = { object: Date.new(2012, 12, 20), string: '20-12-2012' }
    @payday = { object: Date.new(2012, 1, 31), string: '31-01-2012' }
  end

  scenario 'converts dates from specified format' do
    visit new_event_path
    fill_in 'Start date', with: @start_date[:string]
    fill_in 'End date', with: @end_date[:string]
    fill_in 'Judgement day', with: @judgement_day[:string]
    fill_in 'Payday', with: @payday[:string]
    click_button 'Save'

    page.should have_content "Start date: #{@start_date[:string]}"
    page.should have_content "End date: #{@end_date[:string]}"
    page.should have_content "Judgement day: #{@judgement_day[:string]}"
    page.should have_content "Payday: #{@payday[:string]}"

    event = Event.last
    event.start_date.should == @start_date[:object]
    event.end_date.should == @end_date[:object]
    event.judgement_day.should == @judgement_day[:object]
    event.payday.should == @payday[:object]
  end

  scenario 'shows correctly configured dates on html fields' do
    event = Event.create!(
      start_date: @start_date[:object],
      end_date: @end_date[:object],
      judgement_day: @judgement_day[:object],
      payday: @payday[:object])
    visit edit_event_path(event)
    field_labeled('Start date').value.should == @start_date[:string]
    field_labeled('End date').value.should == @end_date[:string]
    field_labeled('Judgement day').value.should == @judgement_day[:string]
    field_labeled('Payday').value.should == @payday[:string]
  end
end
