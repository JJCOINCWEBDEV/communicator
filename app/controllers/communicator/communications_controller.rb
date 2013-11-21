class Communicator::CommunicationsController < ActionController::Base
  before_filter :check_authorization!, :event, only: [:register, :subscribe, :listen]

  def register
    @communication.register
    respond_success
  end

  def subscribe
    @communication.subscribe
    respond_success
  end

  def listen
    @communication.receive
    respond_success
  end

  Communicator.configuration.listeners.each do |event, observer_class_name|
    define_method "listen_#{event}" do
      observer_class_name.constantize.new.submit(params)
      respond_success
    end
  end if Communicator.configuration.listener

  private

  def check_authorization!
    unless params[:access_key] && params[:access_key] == Communicator.configuration.secret_key
      render text: "Access Denied"
    end
  end

  def event
    @communication ||= Communicator::Communication.new(params)
  end

  def respond_success
    render text: 'success'
  end

end
