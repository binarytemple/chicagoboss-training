-module(training_chatroom_controller, [Req, SessionID]).
-compile(export_all).

console('GET', []) ->
%%   boss_flash:add(SessionID, notice, "Flash Title", "Flash Message"),
  %%boss_session:new_session("foo"),
  boss_session:set_session_data(SessionID, "bar", "baz"),
  lager:log(info, self(), "~p console", [training_chatroom_controller]),
  {ok, [{username,
    boss_session:get_session_data(SessionID,username)
  }]}.

history('GET', []) ->
  lager:log(info, self(), "~p list", [training_chatroom_controller]),
  Chats = boss_db:find(chat, []),
  lager:log(info, self(), "Req:  ~p ", [Req]),
  lager:log(info, self(), "Chats :  ~p ", [Chats]),
  {ok, [{chats, Chats}]}.

list('POST', []) ->
  lager:log(info, self(), "Req:  ~p ", [Req]),
  lager:log(info, self(), "~p list", [training_chatroom_controller]),
  Chat = chat:new(id, Req:post_param("chat")),
  Create = Chat:save(),
  case Create of
    {ok, NewChat} ->
      Chats = boss_db:find(chat, []),
      {ok, [{chats, Chats}]};
    {error, [ErrorMessages]} ->
      {ok, [{errors, ErrorMessages}]}
  end.
