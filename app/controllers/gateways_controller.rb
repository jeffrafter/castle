class GatewaysController < ApplicationController
  # GET /gateways
  # GET /gateways.xml
  def index
    @gateways = Gateway.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gateways }
    end
  end

  # GET /gateways/1
  # GET /gateways/1.xml
  def show
    @gateway = Gateway.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gateway }
    end
  end

  # GET /gateways/new
  # GET /gateways/new.xml
  def new
    @gateway = Gateway.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gateway }
    end
  end

  # GET /gateways/1/edit
  def edit
    @gateway = Gateway.find(params[:id])
  end

  # POST /gateways
  # POST /gateways.xml
  def create
    @gateway = Gateway.new(params[:gateway])

    respond_to do |format|
      if @gateway.save
        flash[:notice] = 'Gateway was successfully created.'
        format.html { redirect_to(@gateway) }
        format.xml  { render :xml => @gateway, :status => :created, :location => @gateway }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gateway.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gateways/1
  # PUT /gateways/1.xml
  def update
    @gateway = Gateway.find(params[:id])

    respond_to do |format|
      if @gateway.update_attributes(params[:gateway])
        flash[:notice] = 'Gateway was successfully updated.'
        format.html { redirect_to(@gateway) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gateway.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gateways/1
  # DELETE /gateways/1.xml
  def destroy
    @gateway = Gateway.find(params[:id])
    @gateway.destroy

    respond_to do |format|
      format.html { redirect_to(gateways_url) }
      format.xml  { head :ok }
    end
  end
end
