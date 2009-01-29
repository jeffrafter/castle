class AreasController < ApplicationController
  before_filter :find_area, :except => [:index, :new, :create]
 
  def index
    @areas = Area.find(:all)
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = 'Area created.' and redirect_to(@area) 
    else
      render :action => "new" 
    end
  end

  def show
  end

  def edit
  end

  def update
    if @area.update_attributes(params[:area])
      flash[:notice] = 'Area updated.' and redirect_to(@area) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @area.destroy
    redirect_to(areas_url) 
  end
  
private
  
  def find_area
    @area = Area.find(params[:id])
    
  end

end
