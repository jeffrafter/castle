class InboxController < ApplicationController
  resource_controller
  responds_to :xml
  before_filter :find_gateway
  
  def create
    @inbox = Inbox.create(params[:inbox])
    @user = User.find_by_number(@inbox.number)
    
    # Deactivated users
    raise RuntimeError if @user && !@user.active?
    
    # New users
    unless @user
      invite(@inbox.number)
      render :nothing => true, :status => :ok    
      return
    end    
    
    # New user confirming
    unless (@user.number_confirmed?)
      if @inbox.text.chomp.downcase == 'yes'
        Outbox.create(:number => @user.number, :gateway => @gateway,
          :text => 'Thanks for joining. To get help, reply to this message with "help"')
        @user.number_confirmed = true
        @user.save!
      end  
      render :nothing => true, :status => :ok    
      return
    end

    # need to think about state here
    begin
      handle(Command.new(params[:inbox]))
    rescue InvalidCommandError  
      Outbox.create(:number => @user.number, :gateway => @gateway,
       :text => 'What do you mean?')          
    end      
    
    # The response from this is non-important
    render :nothing => true, :status => :ok
  end

    
private  

  def handle(command)
    case command.keyword
      when :invite    
        number = Number.validate(command.arguments)
        invite(number)
      when :help
        help(command.number)    
    end
  end
  
  def invite(number)
    user = User.find_by_number(number)
    return if user && user.number_confirmed?
    user = User.create(:number => number) unless user
    Outbox.create(:number => number, :gateway => @gateway,
      :text => 'You have been invited to join the Knight Foundation RANC SMS news Server. Please confirm you are interested by replying with "yes"')
  end  
  
  def help(number)
    Outbox.create(:number => number, :gateway => @gateway,
      :text => 'Invite your friends by sending "invite +19995551212". More commands are coming soon.')
  end
  
end
