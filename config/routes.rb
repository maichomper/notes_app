# frozen_string_literal: true

Rails.application.routes.draw do
  resources :folder

  post 'folder/add_note' => 'folder#add_note'
  get 'folder/search/:name' => 'folder#search'

  root 'folder#show'
end
