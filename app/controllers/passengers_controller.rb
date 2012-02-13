class PassengersController < ApplicationController
  # GET /passengers
  # GET /passengers.json
  def index
    @passengers = Passenger.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @passengers }
    end
  end

  # GET /passengers/1
  # GET /passengers/1.json
  def show
    idpasajero=params[:id]
    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :obtenerPasajero do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idPasajero>" + idpasajero + "</idPasajero>"    
    end
    if response.success?
      @passenger = response.to_hash

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @passenger }
      end
    end
  end

  # GET /passengers/new
  # GET /passengers/new.json
  def new
    @passenger = Passenger.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @passenger }
    end
  end

  # GET /passengers/1/edit
  def edit
    #@passenger = Passenger.find(params[:id])
    idpasajero=params[:id]
    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :obtenerPasajero do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idPasajero>" + idpasajero + "</idPasajero>"    
    end
    if response.success?
      @passenger = response.to_hash
    end
  end

  # POST /passengers
  # POST /passengers.json
  def create

    @passenger = Passenger.new(params[:passenger])
    lastname=@passenger.last_name
    firstname=@passenger.first_name
    email=@passenger.email
    password=@passenger.password
    user=@passenger.user

    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :registrarPasajero do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<pasajero><apepaterno>" + lastname + "</apepaterno><apematerno></apematerno><correo>" + email + "</correo><nombre>" + firstname + "</nombre><password>" + password + "</password><usuario>" + user + "</usuario></pasajero>"    
    end

    if response.success?
      @passenger = response.to_hash
      respond_to do |format|
        if @passenger[:registrar_pasajero_response][:return][:codigo]=="0"
          format.html { redirect_to "/passengers/"+@passenger[:registrar_pasajero_response][:return][:pasajero][:idpasajero], notice: @passenger[:registrar_pasajero_response][:return][:mensaje] }
          format.json { render json: @passenger[:registrar_pasajero_response][:return][:mensaje], status: :created, location: @passenger}
        else
         format.html { render action: "new" }
         format.json { render json: @passenger[:registrar_pasajero_response][:return][:mensaje], status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /passengers/1
  # PUT /passengers/1.json
  def update
    @passenger = Passenger.find(params[:id])

    respond_to do |format|
      if @passenger.update_attributes(params[:passenger])
        format.html { redirect_to @passenger, notice: 'Passenger was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @passenger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passengers/1
  # DELETE /passengers/1.json
  def destroy
    @passenger = Passenger.find(params[:id])
    @passenger.destroy

    respond_to do |format|
      format.html { redirect_to passengers_url }
      format.json { head :ok }
    end
  end
end
