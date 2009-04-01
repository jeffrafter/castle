class LogController < ApplicationController
  before_filter :find_gateway, :only => [:create]
  skip_before_filter :authenticate, :only => [:create]
  rescue_from Exception do |e| render :text => e.message, :status => :error; end
  
  def create
    kind = (params[:kind] || 'default')
    filename = File.join(RAILS_ROOT, 'log', @gateway.api_key, kind, Time.now.strftime("%Y%m%dT%H:%M:%S.log"))
    FileUtils.mkpath(File.extract_path(filename))
    File.open(filename, 'w') do |file|
      file.write(params[:text])
    end
    render :nothing => true, :status => :ok      
  end    
end
