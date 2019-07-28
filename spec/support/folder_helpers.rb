# frozen_string_literal: true

module FolderHelpers
  def create_subfolders_with_notes(parent_folder, folder_depth, notes_per_folder)
    return unless folder_depth > 0

    subfolder = Folder.create(name: "folder#{folder_depth}", parent_id: parent_folder.id)
    notes_per_folder.times { |i| Note.create(name: "note_#{folder_depth}_#{i}", folder: subfolder) }

    create_subfolders_with_notes(subfolder, folder_depth - 1, notes_per_folder)
  end
end
