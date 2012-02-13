class FlightsController < ApplicationController
  # GET /flights
  def index

    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :obtenerListaVuelos do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
    end

    if response.success?

     @flights=response.to_hash()
      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flights }
     end

    end  
    
  end

  # GET /flights/1
  # GET /flights/1.json
  def show
    idvuelo=params[:id]
    client_flight = Savon::Client.new (ruta_wdsl)
    client_flight.wsdl.soap_actions
    response_flight = client_flight.request :ser, :obtenerVuelo do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idVuelo>" + idvuelo + "</idVuelo>"    
    end
    if response_flight.success?
      @flight = response_flight.to_hash
    end
    
    client_seat = Savon::Client.new (ruta_wdsl)
    client_seat.wsdl.soap_actions
    response_seat = client_seat.request :ser, :obtenerAsientos do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idVuelo>" + idvuelo + "</idVuelo>"    
    end

    if response_seat.success?
      @seats = response_seat.to_hash
      Rails.logger.info @seats[:obtener_asientos_response].size.inspect
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @flight }
        format.json { render json: @seats }
      end
    end
  end

  # GET /flights/new
  # GET /flights/new.json
  def new
    @flight = Flight.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flight }
    end
  end

  # GET /flights/1/edit
  def edit
    #@flight = Flight.find(params[:id])
    idvuelo=params[:id]
    client_flight = Savon::Client.new (ruta_wdsl)
    client_flight.wsdl.soap_actions
    response_flight = client_flight.request :ser, :obtenerVuelo do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idVuelo>" + idvuelo + "</idVuelo>"    
    end
    if response_flight.success?
      @flight = response_flight.to_hash
    end
    
    client_seat = Savon::Client.new (ruta_wdsl)
    client_seat.wsdl.soap_actions
    response_seat = client_seat.request :ser, :obtenerAsientos do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idVuelo>" + idvuelo + "</idVuelo>"    
    end

    if response_seat.success?
      @asientos = response_seat.to_hash
      @asientos[:obtener_asientos_response][:return].each do |asiento|
        s=Seat.new
        s.id_asiento = asiento[:id_asiento]
        s.numero = asiento[:numero] 
        s.posicion = asiento[:descripcion]
        s.flight_id = asiento[:id_vuelo]
        s.save
      end

      @seats = Seat.all
    
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @flight }
        format.json { render json: @seats }
      end
    end
  end

  # POST /flights
  # POST /flights.json
  def create
    @flight = Flight.new(params[:flight])

    respond_to do |format|
      if @flight.save
        format.html { redirect_to @flight, notice: 'Flight was successfully created.' }
        format.json { render json: @flight, status: :created, location: @flight }
      else
        format.html { render action: "new" }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flights/1
  # PUT /flights/1.json
  def update
    @flight = Flight.find(params[:id])

    respond_to do |format|
      if @flight.update_attributes(params[:flight])
        format.html { redirect_to @flight, notice: 'Flight was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.json
  def destroy
    @flight = Flight.find(params[:id])
    @flight.destroy

    respond_to do |format|
      format.html { redirect_to flights_url }
      format.json { head :ok }
    end
  end
end
