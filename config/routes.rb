Communicator::Engine.routes.draw do
  if Communicator.configuration.role == 'master'
    post :register, to: "communications#register"
    post :subscribe, to: "communications#subscribe"
    post :listen, to: "communications#listen"
  end

  Communicator.configuration.listeners.keys.each do |event|
    post 'listen/:event', to: "communications#listen_#{event}"
  end if Communicator.configuration.listeners
end
