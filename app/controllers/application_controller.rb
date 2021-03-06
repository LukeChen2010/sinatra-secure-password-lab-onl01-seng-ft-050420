require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    #your code here
    
    username = params[:username]
    password = params[:password]
    
    if username == "" || password == ""
      redirect '/failure'
    else
      User.create(username: username, password_digest: password)
      redirect '/login'
    end
    
  end
  
  get '/failure' do
    erb :failure
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    ##your code here
    
    username = params[:username]
    password = params[:password]
    
    @user = User.find_by(username: username)
    if username == "" || password == "" || !@user.authenticate(params[:password])
      redirect '/failure'
    else
      session[:user_id] = @user.id
      redirect to "/account"
    end
  end

  get '/failure' do
    erb :failure
  end
  
  get '/account' do
    erb :account
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
