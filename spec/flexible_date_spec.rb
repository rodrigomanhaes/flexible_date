# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'flexible date' do
  it 'allows blank values' do
    event = Event.new(:payday_flex => "", :description => "")
    event.should be_valid
  end

  it 'allows mass assignment of suffixed attributes' do
    expect {
      Event.new(payday_flex: nil, judgement_day_yyz: nil,
                start_date_flex: nil, end_date_flex: nil)
    }.to_not raise_error ActiveModel::MassAssignmentSecurity::Error
  end

  context 'should respond to the conditions params' do
    before(:each) { I18n.locale = :br }
    after(:each) { I18n.locale = :en }

    context "when the condition isn't satisfied" do
      before(:each) { @event = Event.new(:description => "some description") }

      it 'with empty date' do
        @event.payday_flex = ""
        @event.should_not be_valid
        @event.errors[:payday].should == ["inválida."]
        @event.errors[:payday_flex].should == ["inválida."]
      end

      it 'without empty date' do
        @event.payday_flex = "20/05/2011"
        @event.should_not be_valid
        @event.errors[:payday_flex].should == ["inválida."]
        @event.errors[:payday].should == ["inválida."]
      end
    end

    it 'when the condition is satisfied' do
      event = Event.new(:description => "")
      event.payday_flex = "20/05/2011"
      event.should be_valid
    end
  end

  context 'suffixes' do
    it '_flex by default' do
      event = Event.new
      event.should respond_to(:start_date_flex)
      event.should respond_to(:start_date_flex=)
      event.should respond_to(:end_date_flex)
      event.should respond_to(:end_date_flex=)
    end

    it 'can be customized' do
      event = Event.new
      event.should respond_to(:judgement_day_yyz)
      event.should respond_to(:judgement_day_yyz=)
    end
  end

  context 'for invalid dates' do
    it 'invalidates the model' do
      event = Event.new
      event.start_date_flex = "31/04/2010"
      event.should_not be_valid
      event.errors[:start_date_flex].should be_any
      event.errors[:start_date].should be_any
    end

    it 'assigns nil' do
      event = Event.new
      event.start_date_flex = '30/04/2010'
      event.start_date_flex = '31/04/2010'
      event.start_date_flex.should be_nil
    end
  end

  context 'customize date format with I18n' do
    context 'default_locale br' do
      before(:each) { I18n.locale = :br }

      it 'converts formatted inputs to respective fields' do
        event = Event.new
        event.start_date_flex = "31/01/2011"
        event.judgement_day_yyz =  "28/02/2011"
        event.start_date.should == Date.new(2011, 01, 31)
        event.judgement_day.should == Date.new(2011, 02, 28)
      end

      it 'returns dates formatted as configured' do
        event = Event.new :start_date => '31/01/2011',
                          :end_date => Date.new(2011, 02, 28)
        event.start_date_flex.should == "31/01/2011"
        event.end_date_flex.should == "28/02/2011"
      end
    end

    context 'default_locale en' do
      before(:each) { I18n.locale = :en }

      it 'converts formatted inputs to respective fields' do
        event = Event.new
        event.start_date_flex = "31-01-2011"
        event.judgement_day_yyz =  "28-02-2011"
        event.start_date.should == Date.new(2011, 01, 31)
        event.judgement_day.should == Date.new(2011, 02, 28)
      end

      it 'returns dates formatted as configured' do
        event = Event.new :start_date => '31-01-2011',
                          :end_date => Date.new(2011, 02, 28)
        event.start_date_flex.should == "31-01-2011"
        event.end_date_flex.should == "28-02-2011"
      end
    end
  end

  context 'customize error messages with I18n' do
    context 'default_locale br' do
      before(:each) { I18n.locale = :br }

      it 'invalid date' do
        event = Event.new
        event.start_date_flex = "31/04/2010"
        event.should_not be_valid
        event.errors[:start_date_flex].should == ["inválida."]
        event.errors[:start_date].should == ["inválida."]
      end
    end

    context 'defaul_locale en' do
      before(:each) { I18n.locale = :en }

      it 'invalid date' do
        event = Event.new
        event.start_date_flex = "31/04/2010"
        event.should_not be_valid
        event.errors[:start_date_flex].should == ["invalid."]
        event.errors[:start_date].should == ["invalid."]
      end
    end
  end

  context 'for datetime fields' do
    before(:each) { I18n.locale = :en }

    it 'valid datetime' do
      event = Event.new
      event.created_at_flex = "30-04-2010 22:15:59"
      event.should be_valid
    end

    it 'invalid datetime' do
      event = Event.new
      event.created_at_flex = "30-04-2010"
      event.should_not be_valid
      event.errors[:created_at_flex].should == ["invalid."]
      event.errors[:created_at].should == ["invalid."]
    end
  end
end
