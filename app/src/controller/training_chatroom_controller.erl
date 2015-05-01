-module(training_chatroom_controller, [Req]).
-compile(export_all).

console('GET', []) ->
    lager:log(info, self(), "~p console", [ training_chatroom_controller ]),
    {ok, [{user,uuid:to_string( uuid:uuid1() ) }]}.

list('GET', []) ->
    lager:log(info, self(), "~p list", [ training_chatroom_controller ]),
    Chats = boss_db:find(chat, []),
    lager:log(info, self(), "Req:  ~p ", [ Req ]),
    lager:log(info, self(), "Chats :  ~p ", [ Chats ]),
    {ok, [{chats, Chats}]};

list('POST', []) ->
    lager:log(info, self(), "Req:  ~p ", [ Req ]),
    lager:log(info, self(), "~p list", [ training_chatroom_controller ]),
    Chat = chat:new(id, Req:post_param("chat")),
    Create = Chat:save(),
    case Create of
        {ok, NewChat} ->
            Chats = boss_db:find(chat, []),
            {ok, [{chats, Chats}]};
        {error, [ErrorMessages]} ->
            {ok, [{errors, ErrorMessages}]}
    end.
