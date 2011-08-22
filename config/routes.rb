Noodnik::Engine.routes.draw do
  get "postpone" => "nags#postpone"

  get "complete" => "nags#complete"

end
