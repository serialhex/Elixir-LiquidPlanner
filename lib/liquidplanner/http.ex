defmodule LiquidPlanner.HTTP do

  require Logger
  use GenServer
  use HTTPoison.Base

  @base_uri Application.get_env(:liquidplanner, :uri)
  @token Application.get_env(:liquidplanner, :token)

  ##############################################################################
  # HTTPoison pre-processors
  def process_url(url) do
    Logger.info inspect(url)
    @base_uri <> url
  end
  def process_request_body(body) do
    Logger.info inspect(body)
    Poison.encode! body
  end
  def process_request_headers(headers) do
    Logger.info inspect(headers)
    [{"Authorization", "Bearer " <> @token},
     {"Content-Type", "application/json"}
     | headers]
  end

  ##############################################################################
  # Look into making these better with macros...
  def account do
    case get("/account") do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def workspaces do
    case get("/workspaces") do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def projects do
    case get "/workspaces/#{workspace_id()}/projects" do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def tasks do
    case get "/workspaces/#{workspace_id()}/tasks" do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def create_task(data \\ []) do
    data = Enum.into(data, %{})
    body = %{task: data}
    post "/workspaces/#{workspace_id()}/tasks", body
  end

  def update_task(data \\ []) do
    data = Enum.into(data, %{})
    body = %{task: data}
    put "/workspaces/#{workspace_id()}/tasks/#{data[:id]}", body
  end

  ##############################################################################
  # Under-the-hood
  def workspace_id do
    GenServer.call(__MODULE__, :workspace_id)
  end

  ##############################################################################
  # GenServer Stuff...
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # change this
  def init(_args) do
    # wksp = workspaces()
    {:ok, %{}}
  end

  # and these...
  def handle_call(:workspace_id, _from, db) do
    case Map.get(db, :workspace_id) do
      nil ->
        wksp = workspaces() |> hd |> Map.get("id")
        Logger.debug "Workspace: #{inspect(wksp)}, DB: #{inspect(db)}"
        {:reply, wksp, Map.put(db, :workspace_id, wksp)}
      id ->
        {:reply, id, db}
    end
  end
  # def handle_call(:file, _from, db) do
  #   {:reply, db[:file], db}
  # end
  # def handle_call({:data, key}, _from, db) do
  #   {:reply, Map.fetch(db[:data], key), db}
  # end
  # def handle_call({:data, :events, value}, _from, db) do
  #   evs = get_in(db, [:data, :events])
  #   data = put_in(db, [:data, :events], [value | evs])
  #   case write_db(db[:file], data[:data]) do
  #     :ok -> {:reply, :ok, data}
  #     derp -> derp
  #   end
  # end
  # def handle_call({:data, keys, value}, _from, db) do
  #   data = put_in(db, [:data] ++ keys, value)
  #   case write_db(db[:file], data[:data]) do
  #     :ok -> {:reply, :ok, data}
  #     derp -> derp
  #   end
  # end

end
