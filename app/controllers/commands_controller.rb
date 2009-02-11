class CommandsController < ApplicationController
  def create
    @command = Command.new(params[:command])
    self.send(@command.keyword)
    respond_to do |format|
      format.html { render :nothing => true, :status => :ok }
      format.xml  { render :nothing => true, :status => :ok }
    end    
  end
  
private  
  def invite
    invitee = @command.message
    invitee = '+' + invitee.gsub(/[^0-9]/, '')    
    @user = User.find_by_number(invitee)
    return if @user && @user.number_confirmed?
    @user = User.create(:number => invitee) unless @user
    @message = Message.create(:number => invitee, :message => 'You have been invited to join the Knight Foundation RANC SMS news Server. Please confirm you are interested by replying with "yes"')
  end  
  
  def help
    args = @command.message.split(/\s/)    
    help_on = args.shift
    @message = Message.create(:number => @command.number, :message => 'Invite your friends by sending "invite +19995551212". More commands are coming soon.')
  end
end
