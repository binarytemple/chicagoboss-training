-module(training_chat_protocol_websocket, [Req, SessionId]).
-behaviour(boss_service_handler).
-record(state, {users}).

%% API
-export([init/0,
  handle_incoming/4,
  handle_join/3,
  handle_broadcast/2,
  handle_close/4,
  handle_info/2,
  terminate/2]).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init() ->
  io:format("~p (~p) starting...~n", [?MODULE, self()]),
  %timer:send_interval(1000, ping),
  {ok, #state{users = dict:new()}}.

handle_join(_ServiceName, WebSocketPid, State) ->
  #state{users = Users} = State,
  {noreply, #state{users = dict:store(WebSocketPid, SessionId, Users)}}.

handle_close(Reason, ServiceName, WebSocketId, State) ->
  #state{users = Users} = State,
  io:format("Service ~p - WSPid ~p closed for reason ~p~n",
    [ServiceName, WebSocketId, Reason]),
  {noreply, #state{users = dict:erase(WebSocketId, Users)}}.

handle_broadcast(Message, State) ->
  io:format("Broadcast Message ~p~n", [Message]),
  {noreply, State}.

%% copy message to all users
handle_incoming(ServiceName, WebSocketId, Message, State) ->
  %% lager:info(self(),"~p ~p ~p ~p ~p ~p",[  Req, SessionId, ServiceName, WebSocketId, Message, State]),
  %% lager:info(self(),"~p~n",mochijson2:decode(Message)),
  %% try
  %%     Decoded =  mochijson:decode(Message),
  %%     lager:info(self(),"decoded message : ~p ~n",[ Decoded ])
  %% catch
  %%     error:Error ->
  %%     lager:error(self(),"unable to decode message : ~p ~n",[ Message ])
  %% end,

  DecodedMessage = jsx:decode(Message),
  lager:log(info, self(), "SessionId = ~p, Message = ~p - ~p", [SessionId, Message, DecodedMessage]),

  store_message(
    proplists:get_value(<<"user">>, DecodedMessage),
    proplists:get_value(<<"message">>, DecodedMessage)
  ),

  #state{users = Users} = State,
  Fun = fun(X) when is_pid(X) -> X ! {text, Message} end,
  All = dict:fetch_keys(Users),
  [Fun(E) || E <- All, E /= WebSocketId],
  %% end,
  {noreply, State}.


store_message(undefined, _) ->
  lager:log(info, self(), "Param missing", []),

  {error, missing_parameter}
;
store_message(_, undefined) ->
  lager:log(info, self(), "Param missing", []),
  {error, missing_parameter}
;
store_message(User, Message) ->
  lager:log(info, self(), "Both param", []),
  Chat = chat:new(id, User, Message, undefined),
  Create = Chat:save(),
  {ok, Create}
.

handle_info(ping, State) ->
  error_logger:info_msg("pong:~p~n", [now()]),
  {noreply, State};

handle_info(state, State) ->
  #state{users = Users} = State,
  All = dict:fetch_keys(Users),
  error_logger:info_msg("state:~p~n", [All]),
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  %call boss_service:unregister(?SERVER),
  ok.

%% Internal functions
