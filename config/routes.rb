require "resque_web"


Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
