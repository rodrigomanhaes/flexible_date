class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :start_date
      t.date :end_date
      t.date :judgement_day
      t.date :payday
      t.string :description

      t.timestamps
    end
  end
end
