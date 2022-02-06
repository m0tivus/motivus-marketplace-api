defmodule MotivusMarketplaceApi.Account.ApplicationTokenPipeline do
  @moduledoc """
  Handles whitelisting of routes using application_tokens.
  Relies on 'mwbat' token implementation for Guardian, see MotivusMarketplaceApi.Account.JwtOrMwbt 
  """
  import Plug.Conn

  def init(config), do: List.keyfind(config, :allowed, 0)

  @doc """
  Checks for allowed paths and actions when using application_token authentication
  """
  def call(
        %{private: %{guardian_default_claims: %{"typ" => "mwbat"}}} = conn,
        {:allowed, allowed}
      ) do
    %{helper: helper, plug_opts: action} = get_path_info(conn)

    with {_, actions_allowed} <-
           List.keyfind(allowed, String.to_atom(helper), 0),
         true <- action in to_list(actions_allowed) do
      conn
    else
      _ ->
        conn
        |> resp(:forbidden, "Not allowed using this token")
        |> halt()
    end
  end

  def call(conn, _opts), do: conn

  defp to_list(list) when is_list(list), do: list
  defp to_list(element), do: [element]

  defp get_path_info(conn) do
    %{host: host, method: method, request_path: request_path} = conn

    %{plug: controller, plug_opts: action} =
      Phoenix.Router.route_info(MotivusMarketplaceApiWeb.Router, method, request_path, host)

    Phoenix.Router.routes(MotivusMarketplaceApiWeb.Router)
    |> Enum.filter(fn %{plug: p, plug_opts: po} ->
      p == controller and po == action
    end)
    |> List.first()
  end
end
