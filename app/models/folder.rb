# frozen_string_literal: true

class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_id'
  has_many :notes

  validates :name, presence: true

  def path_folders
    return [self] unless parent_id

    parent.path_folders + [self]
  end

  # Return all Notes in current folder and all of its subfolders.
  def descendent_notes
    subtree = self.class.tree_sql_for(self)
    Note.where("folder_id IN (#{subtree})")
  end

  def self.tree_sql_for(instance)
    <<-SQL
        WITH RECURSIVE folder_tree(id, path) AS (
            SELECT id, ARRAY[id]
            FROM #{table_name}
            WHERE id = #{instance.id}
          UNION ALL
            SELECT #{table_name}.id, path || #{table_name}.id
            FROM folder_tree
            JOIN #{table_name} ON #{table_name}.parent_id = folder_tree.id
            WHERE NOT #{table_name}.id = ANY(path)
        )
        SELECT id FROM folder_tree ORDER BY path
    SQL
  end
end
