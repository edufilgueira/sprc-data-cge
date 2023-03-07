Rails.application.routes.draw do
  require 'sidekiq/web'

  # XXX: apenas para teste pois a forma correta seria obrigar a autenticação
  # Devemos centralizar o controle do sidekiq na aplicação principal
  mount Sidekiq::Web => '/sidekiq'

  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  namespace :api do
    namespace :v1 do
      resources :importers, only: [:create]
      resources :sidekiq_monitor, only: [:index]

      namespace :publications, defaults: {format: 'json'}  do
        resources :contracts, only: [:create, :destroy], param: :isn_sic
        resources :adjustments, only: [:create, :destroy], param: :isn_contrato_ajuste
        resources :additives, only: [:create, :destroy], param: :isn_contrato_aditivo
        resources :convenants, only: [], param: :isn_sic do
          get 'turn_on_confidential', on: :member
          get 'turn_off_confidential', on: :member
        end
      end
    end
  end
end

