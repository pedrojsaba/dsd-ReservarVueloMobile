class SeatsController < ApplicationController
  # GET /seats
  # GET /seats.json
  def index
    @seats = Seat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seats }
    end
  end

  # GET /seats/1
  # GET /seats/1.json
  def show
    @seat = Seat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seat }
    end
  end

  # GET /seats/new
  # GET /seats/new.json
  def new
    @seat = Seat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seat }
    end
  end

  # GET /seats/1/edit
  def edit
    #@seat = Seat.find(params[:id])
    Seat.destroy_all
    idasiento=params[:id]
    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :obtenerAsiento do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<idAsiento>" + idasiento + "</idAsiento>"
    end

    if response.success?
      @datos=response.to_hash()
      
      s=Seat.new
      s.id_asiento=@datos[:obtener_asiento_response][:return][:id_asiento]
      s.numero=@datos[:obtener_asiento_response][:return][:numero]
      s.posicion=@datos[:obtener_asiento_response][:return][:descripcion]
      s.flight_id=@datos[:obtener_asiento_response][:return][:id_vuelo]
      s.save
      
      @seat=Seat.first
    end
  end

  # POST /seats
  # POST /seats.json
  def create
    @seat = Seat.new(params[:seat])

    respond_to do |format|
      if @seat.save
        format.html { redirect_to @seat, notice: 'Seat was successfully created.' }
        format.json { render json: @seat, status: :created, location: @seat }
      else
        format.html { render action: "new" }
        format.json { render json: @seat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seats/1
  # PUT /seats/1.json
  def update
    @seat = Seat.find(params[:id])
    idasiento=@seat.id_asiento.to_s
    client = Savon::Client.new (ruta_wdsl)
    client.wsdl.soap_actions
    response = client.request :ser, :reservarAsiento do
      soap.namespaces["xmlns:ser"] = "http://service.wsreserva.qwerty.dsd.upc.edu.pe/"
      soap.body = "<usuario>ecampos</usuario><password>ecampos</password><idAsiento>"+idasiento+"</idAsiento>"
    end

    if response.success?
      @seat=response.to_hash()
      respond_to do |format|
        if @seat[:reservar_asiento_response][:return][:codigo]=="0"
          format.html { redirect_to "/", notice: @seat[:reservar_asiento_response][:return][:mensaje] }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @seat[:reservar_asiento_response][:return][:mensaje], status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /seats/1
  # DELETE /seats/1.json
  def destroy
    @seat = Seat.find(params[:id])
    @seat.destroy

    respond_to do |format|
      format.html { redirect_to seats_url }
      format.json { head :ok }
    end
  end
end
