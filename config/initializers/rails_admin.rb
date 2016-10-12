include Pundit

RailsAdmin.config do |config|

  ### Popular gems integration
  config.authenticate_with do
    require_login
  end

  # Because "::ActionController::Base" is default parent_controller
  config.parent_controller = 'ApplicationController'

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  config.authorize_with :pundit

  config.current_user_method(&:current_user)
  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index

    new do
      except 'User'
    end
    # export
    # bulk_delete
    show
    edit
    delete do
      except ['User', 'Authentication']
    end
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    list do
      field :id
      field :email
      field :current_block
      field :locale
      field :roles
      field :created_at
      field :updated_at
    end

    show do
      field :id
      field :email
      field :current_block
      field :locale
      field :created_at
      field :updated_at
    end

    edit do
      field :email
      field :current_block
      field :locale
    end
  end
end
