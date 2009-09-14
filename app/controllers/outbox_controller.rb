class OutboxController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        authenticate
        if params[:number]
          @messages = Outbox.paginate_by_number(params[:number], :page => params[:page], :per_page => 10, :order => 'created_at DESC')
        else
          @messages = Outbox.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
        end          
      }  
      format.xml {
        find_gateway
        since = Time.zone.parse(params[:since]) rescue nil
        options = {}
        options[:conditions] = ['updated_at > ?', since] if since
        @messages = Outbox.local(@gateway.id).all(options)
        # May want this eventuall: render :nothing => true, :status => 200 and return if @messages.blank?
        render :xml => @messages.to_xml, :status => 200
      }
    end    
  end
end
