# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FolderController, type: :controller do
  let(:root_folder) { Folder.find_by(name: 'root') }

  describe 'GET #show' do
    let(:img_folder) { Folder.create(name: 'img') }

    before { get :show, params: { id: img_folder.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the Folder view' do
      expect(response).to render_template('show')
    end

    it 'assigns current_folder' do
      expect(assigns[:current_folder]).to eq img_folder
    end

    it "returns all Folder's names used for autocomplete" do
      expect(assigns[:all_folders]).to eq ['root', img_folder.name]
    end
  end

  describe 'POST #create' do
    let(:media_folder) { Folder.create(name: 'media', parent_id: root_folder.id) }

    describe 'when successful' do
      let(:folder_params) do
        {
          folder: { name: 'vid', parent_id: media_folder }
        }
      end

      before { post :create, params: folder_params }

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to media_folder' do
        expect(response).to redirect_to action: :show, id: media_folder.id
      end

      it 'creates a new Folder' do
        last_folder = Folder.last
        expect(last_folder.name).to eq 'vid'
      end
    end

    describe 'when not successful' do
      let(:folder_params) do
        {
          folder: { name: '', parent_id: media_folder.id }
        }
      end

      before { post :create, params: folder_params }

      it 'returns an error message' do
        expect(flash[:error]).to eq "Name can't be blank"
      end
    end
  end

  describe 'POST #add_note' do
    let(:vid_folder) { Folder.create(name: 'videos', parent_id: root_folder.id) }

    describe 'when successful' do
      let(:note_params) do
        {
          note: { name: 'cats.mov', folder_id: vid_folder.id }
        }
      end

      before { post :add_note, params: note_params }

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to vid_folder' do
        expect(response).to redirect_to action: :show, id: vid_folder.id
      end

      it 'creates a new note' do
        last_note = Note.last
        expect(last_note.name).to eq 'cats.mov'
        expect(last_note.folder).to eq vid_folder
      end
    end

    describe 'when not successful' do
      context 'because name is empty' do
        let(:note_params) do
          {
            note: { name: '', folder_id: vid_folder.id }
          }
        end

        before { post :add_note, params: note_params }

        it 'returns an error message' do
          expect(flash[:error]).to eq "Name can't be blank"
        end
      end

      context 'because name is already taken' do
        let(:note_params) do
          {
            note: { name: 'some_note.txt', folder_id: vid_folder.id }
          }
        end

        before do
          Note.create(name: 'some_note.txt', folder_id: vid_folder.id)

          post :add_note, params: note_params
        end

        it 'returns an error message' do
          expect(flash[:error]).to eq 'Name has already been taken'
        end
      end
    end
  end

  describe 'GET #search' do
    let(:folder_depth) { 3 }
    let(:notes_per_folder) { 3 }

    before do
      create_subfolders_with_notes(root_folder, folder_depth, notes_per_folder)
      get :search, params: { name: 'root' }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all Notes in root and its subfolders' do
      expect(assigns[:notes]).to match_array Note.all
    end
  end
end
