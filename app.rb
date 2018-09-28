require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './funcs.rb'
require './models'
require 'xmlsimple'
require 'kaminari'


enable :sessions

get '/' do 
    sleep(7)
    keido = params['keido']
    ido = params['ido']
    
    data = {
        "keido" => keido,
        "ido" => ido
    }
    session['ido'] = ido
    session['keido'] = keido
    
    p "***(トップ)sessionの値***"
    p session['ido']
    p session['keido']
 
    erb :toppage
end

#新規登録
get '/signup' do
    erb :signup
end

post '/signup' do
  @user = User.create(name: params[:name], email: params[:email], password: params[:password],
                      password_confirmation: params[:password_confirmation])
  if @user != nil
    session[:user]=@user.id
  end
  redirect '/signin'
end

#ログイン
get '/signin' do
    p "***(ログイン)sessionの値***"
    p session['keido']
    erb :signin
end

post '/signin' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  
  redirect '/user'
end

get '/signout' do
  session[:user_id] = nil
  redirect '/'
end
 
#プロフィール
get '/user' do
    erb :user
end

#検索ページと検索
get '/search' do
    erb :search
end

post '/search' do
    keyword = params[:keyword]
    new(keyword)
    
    erb :result
end
#近くのカフェ
post '/locate' do
   p "***(カフェサーチ)sessionの値***"
   p session['keido']
   p session['ido']
   
    uri = URI("https://map.yahooapis.jp/search/local/V1/localSearch?appid=dj00aiZpPU5UNmpaZENSQ082TyZzPWNvbnN1bWVyc2VjcmV0Jng9MjY-&lat=#{session['ido']}&lon=#{session['keido']}&dist=5&gc=0115001")
    
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
  
    response = https.get uri.request_uri
    
    hash = XmlSimple.xml_in(response.body)
    
    @shop_name =  hash["Feature"][0]["Name"][0]
    p "***0番目の値***"
    p hash["Feature"][0]
    @shop_location = hash["Feature"][0]["Geometry"][0]["Coordinates"][0]
    
    p "***カフェの名前と座標***"
    p @shop_name
    p @shop_location
    
    sleep(10)
    erb :locate
end



