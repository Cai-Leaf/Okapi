class CreateApis < ActiveRecord::Migration[5.0]
  def change
    create_table :apis do |t|
      t.string :name
      t.string :string
      t.string :version
      t.string :string
      t.string :logo
      t.string :string
      t.string :description
      t.string :string
      t.string :path
      t.string :string

      t.timestamps
    end
  end
end
