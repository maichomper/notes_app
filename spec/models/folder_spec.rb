# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Folder, type: :model do
  # Test all model's attributes
  it { should respond_to(:name) }
  it { should respond_to(:parent_id) }
  # Test validations
  it { should validate_presence_of(:name) }
  # Test associations
  it { should belong_to(:parent) }
  it { should have_many(:notes) }

  describe 'Folder methods' do
    let(:root_folder) { Folder.find_or_create_by(name: 'root') }

    describe '.path_folders' do
      describe 'for root' do
        it 'should return array with itself' do
          path_folders = root_folder.path_folders
          expect(path_folders.count).to eq 1
          expect(path_folders.first.name).to eq root_folder.name
        end
      end

      describe 'for subfolder' do
        let(:subfolder) { Folder.create(name: 'subfolder', parent: root_folder) }

        it 'should return a full path_folders' do
          path_folders = subfolder.path_folders

          expect(path_folders.count).to eq 2
          expect(path_folders.first.name).to eq root_folder.name
          expect(path_folders.last.name).to eq subfolder.name
        end
      end
    end

    describe '.descendent_notes' do
      let(:folder_depth) { 30 }
      let(:notes_per_folder) { 5 }

      before { create_subfolders_with_notes(root_folder, folder_depth, notes_per_folder) }

      it 'should return notes in current follder and its subfolders' do
        all_notes = root_folder.descendent_notes

        expect(all_notes.count).to eq folder_depth * notes_per_folder
      end
    end
  end
end
