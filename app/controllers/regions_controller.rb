class RegionsController < ApplicationController
  before_filter :find_region, :except => [:index, :new, :create]

  def index
    @regions = Region.find(:all)
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new(params[:region])
    if @region.save
      flash[:notice] = 'Region created.' and redirect_to(@region)
    else
      render :action => "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @region.update_attributes(params[:region])
      flash[:notice] = 'Region updated.' and redirect_to(@region)
    else
      render :action => "edit"
    end
  end

  def destroy
    @region.destroy
    redirect_to(regions_url) 
  end
  
private

  def find_region  
    @region = Region.find(params[:id])
  end
  
end
