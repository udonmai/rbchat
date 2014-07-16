Rbchat::Application.routes.draw do

root to: 'login#index'
match '/login',    to: 'login#index',    via: 'get'
match '/square',    to: 'square#index',    via: 'get'
match '/shitsu',    to: 'shitsu#index',    via: 'get'

end
