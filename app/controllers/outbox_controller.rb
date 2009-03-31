class OutboxController < ApplicationController
  skip_before_filter :authenticate
            
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
        since = Time.parse(params[:since]) rescue nil
        options = {}
        options[:conditions] = ['updated_at > ?', since] if since
        @messages = Outbox.all(options)
        render :xml => @messages.to_xml
      }
    end    
  end
end
