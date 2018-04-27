defmodule Chatroom do
  require Logger
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:login, username, node}, {userpid, _}, state) do
    userid = round(:random.uniform * 10000000000)
    Logger.info fn ->
      "User #{username} connected from #{inspect(userpid)} (ID:#{userid})"
    end
    {:reply, {:ok, userid}, Map.put(state, userid, %{username: username,
                                                     pid: userpid,
                                                     node: node})}
  end

  def handle_call({:say, userid, text}, _, state) do
    user = Map.get(state, userid)
    IO.puts "Incoming message from #{inspect(user)}"
    case user do
      nil -> IO.puts "#{userid} is not logged in."
             {:reply, {:error, "Not logged in"}, state}
      %{username: username} -> # Send the text to every other user
                               state
                               |> Map.keys
                               |> Enum.map(fn id -> GenServer.cast(Map.get(state, id).pid, {:text, username, text}) end)
                               {:reply, :ok, state}
    end
  end

end


defmodule Person do
  use GenServer
  require Logger

  def login(username) do
    GenServer.call(__MODULE__, {:login, username})
  end

  def say(text) do
    GenServer.call(__MODULE__, {:say, text})
  end

  def start_link(server) do
    GenServer.start_link(__MODULE__, server, [name: __MODULE__])
  end

  def init(server) do
    {:ok, %{server: server}}
  end

  def handle_call(:get_chat_node, _, state) do
    {:reply, state[:server], state}
  end

  def handle_call({:login, username}, _, state) do
    {:ok, userid} = GenServer.call({Chatroom, state.server}, {:login, username, Node.self()})
    {:reply, userid, Map.merge(state, %{username: username, userid: userid})}
  end

  def handle_call({:say, text}, _, state) do
    reply = GenServer.call({Chatroom, state.server}, {:say, state.userid, text})
    {:reply, reply, state}
  end

  def handle_cast({:text, username, text}, state) do
    Logger.info fn ->
      "[CHAT] #{username} says : #{text}"
    end
    {:noreply, state}
  end

end
