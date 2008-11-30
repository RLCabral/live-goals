class CreateVids < ActiveRecord::Migration
  def self.up
    create_table :vids do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :vids
  end
end
