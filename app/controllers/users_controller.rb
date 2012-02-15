class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = params[:user]
###################
    usuario=@user[:username]
    password=@user[:password]
    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :validarUsuario do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<usuario>" + usuario + "</usuario><password>" + password + "</password>"
    end

    if response.success?
      @response=response.to_hash()
      respond_to do |format|
        if @response[:validar_usuario_response][:return][:codigo]=="0"
          session[:user] = usuario
          session[:pwd] = password
          session[:name] = "usuario" 
          format.html { redirect_to "/", notice: @response[:validar_usuario_response][:return][:mensaje] }
          format.json { head :ok }
        else
          session[:user] = nil
          session[:pwd] = nil
          session[:name] = nil 
          #format.html { render action: "new" }
          #format.json { render json: @response[:validar_usuario_response][:return][:mensaje], status: :unprocessable_entity }
          format.html { redirect_to "/users/new", notice: @response[:validar_usuario_response][:return][:mensaje] }
          #format.json { head :ok }
        end
      end
    end

  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
