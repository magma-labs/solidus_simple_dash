# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    get '/overview', to: 'overview#index', as: :overview
    get '/overview/report_data', to: 'overview#report_data'
  end
end
