class CreateLiveGames < ActiveRecord::Migration
  def self.up
    create_table :live_games do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :live_games
  end
end
