defmodule Google do
  def get_client(token) do
    OAuth2.Client.new(token: token)
  end

  def get_user(token) do
    client = get_client(token)
    resp = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    with %{body: user, status_code: 200} <- resp do
      %GoogleUser{
        email: user["email"],
        name: user["name"],
        avatar: user["picture"],
        access_token: token
      }
    else
      _ -> {:error, message: "Can't get user"}
    end
  end
end
