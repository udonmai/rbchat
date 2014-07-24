Rbchat::Application.routes.draw do

root to: 'login#index'
match '/login',    to: 'login#index',    via: 'get'
match '/login/in',    to: 'login#in',    via: 'post'
match '/square',    to: 'square#index',    via: 'get'
match '/shitsu',    to: 'shitsu#index',    via: 'get'

# square
match '/square/logout',    to: 'square#logout',    via: 'get'

# shitsu 
match '/shitsu/create',    to: 'shitsu#create',    via: 'post'
match '/shitsu/destroy',    to: 'shitsu#destroy',    via: 'post'
match '/shitsu/modify',    to: 'shitsu#modify',    via: 'post'
match '/shitsu/exist',    to: 'shitsu#exist',    via: 'post'
match '/shitsu/checkupdate',    to: 'shitsu#checkupdate',    via: 'post'
match '/shitsu/chat',    to: 'shitsu#chat',    via: 'post'
match '/shitsu/join',    to: 'shitsu#join',    via: 'post'
match '/shitsu/leave',    to: 'shitsu#leave',    via: 'post'

end
