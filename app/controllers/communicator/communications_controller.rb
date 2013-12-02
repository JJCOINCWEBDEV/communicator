class Communicator::CommunicationsController < ActionController::Base
  before_filter :check_authorization!, :communication, only: [:register, :subscribe, :fetch]

  def register
    @communication.register
    respond_success
  end

  def subscribe
    @communication.subscribe
    respond_success
  end

  def fetch
    render json: @communication.fetch
  end

  private

  def check_authorization!
    unless params[:access_key] && params[:access_key] == Communicator.configuration.secret_key
      render text: "Access Denied"
    end
  end

  def communication
    @communication ||= Communicator::Communication.new(params)
  end

  def respond_success
    render text: 'success'
  end

end
