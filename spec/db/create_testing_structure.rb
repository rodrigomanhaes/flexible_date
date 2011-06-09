# -*- encoding : utf-8 -*-
class CreateTestingStructure < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :description
      t.date :start_date
      t.date :end_date
      t.date :judgement_day
      t.date :payday
    end
  end

  def self.down
    drop_table :events
  end
end

