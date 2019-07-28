# frozen_string_literal: true

class FolderController < ApplicationController
  before_action :set_current_folder, only: [:show]
  before_action :set_all_folders, only: %i[show search]

  def show; end

  def create
    new_folder = Folder.create(folder_params)

    if new_folder.errors.any?
      redirect_to new_folder.parent, flash: { error: new_folder.errors.full_messages.first }
      return
    end

    redirect_to new_folder.parent
  end

  def add_note
    new_note = Note.create(note_params)

    if new_note.errors.any?
      redirect_to new_note.folder, flash: { error: new_note.errors.full_messages.first }
      return
    end

    redirect_to new_note.folder
  end

  def search
    @current_folder = Folder.find_by(name: params[:name])
    @notes = @current_folder.descendent_notes
  end

  private

  def set_current_folder
    @current_folder = Folder.find_by(id: params[:id]) || Folder.find_by(name: 'root')
  end

  def set_all_folders
    @all_folders = Folder.pluck(:name)
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def note_params
    params.require(:note).permit(:name, :folder_id)
  end
end
