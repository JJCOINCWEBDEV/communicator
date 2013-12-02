Communicator::Engine.routes.draw do
  if Communicator.configuration.role == 'master'
    post :register, to: "communications#register"
    post :subscribe, to: "communications#subscribe"
    post :fetch, to: "communications#fetch"
  end
end
