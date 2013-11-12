class ChangeNameOfPrivateInMicroposts < ActiveRecord::Migration
  def change
  	rename_column :microposts, :private, :quiet
  end
end
