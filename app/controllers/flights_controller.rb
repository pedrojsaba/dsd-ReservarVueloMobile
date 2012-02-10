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

    @flight = Flight.find(params[:id])
    codigo = @flight.codigo
       
    Seat.destroy_all

    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :obtenerAsientos do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idVuelo>" + codigo + "</idVuelo>"    
    end

    if response.success?

      @datos = response.to_hash

      # Rails.logger.info @datos.inspect

      @datos[:obtener_asientos_response][:return].each do |dato|         
        s=Seat.new 
        s.numero= dato[:numero]
        s.posicion= dato[:descripcion]
        s.vuelo= dato[:id_vuelo]
        s.estado= dato[:estado]
        s.save
      end
    end

    @seats = Seat.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flight }
      format.json { render json: @seats }
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
    @flight = Flight.find(params[:id])
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
