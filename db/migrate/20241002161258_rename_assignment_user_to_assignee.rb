class RenameAssignmentUserToAssignee < ActiveRecord::Migration[8.0]
  def change
    rename_column :assignments, :user_id, :assignee_id
  end
end
