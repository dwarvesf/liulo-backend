defmodule Liulo.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :liulo

  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
