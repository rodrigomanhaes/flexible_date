# -*- encoding : utf-8 -*-
class CreateTestingStructure < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :description
      t.date :start_date
      t.date :end_date
      t.date :judgement_day
    end
  end

  def self.down
    drop_table :events
  end
end

