ActionController::RequestForgeryProtection.module_eval do
=begin
  alias :original_verify_authenticity_token :verify_authenticity_token


  # Need to override the default crsf protection. If we have an incoming
  # request then we need an authorized user token to complete the request,
  # if it is a web request handle it in the default manner
  def verify_authenticity_token(*args)    
    if controller.params[:api_key] && controller.params[:format] == 'xml'      
      key = controller.params[:api_key]
      conditions = ['api_key = ? AND api_key_expires_at < ?', key, Time.now]
      user = User.first(:conditions => conditions)                 
      controller.sign_in_user(user) if user
      raise(ActionController::InvalidAuthenticityToken) unless user
    else
      original_verify_authenticity_token(*args)       
    end 
  end
=end    
end

