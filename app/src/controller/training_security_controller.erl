-module(training_security_controller, [Req, SessionID]).
-compile(export_all).

login('POST', []) ->
  User = Req:post_param("username"),
  Password = Req:post_param("password"),
  lager:log(info, self(), "~p ~p", [User, Password]),
  case Password of
    "foo" ->
      boss_flash:add(SessionID, notice, "Login Successfull", "hello " ++ User),
      boss_session:set_session_data(SessionID, username, User),
      OriginalRequestContext = boss_session:get_session_data(SessionID, original_request_context),
%%       boss_session:remove_session_data(SessionID, original_request_context),
      %but I really want to replay the original request
%%       {redirect,"/"}
      {action_other, [{controller, "base"}, {action, "index"}]} ;
    _ ->
      boss_flash:add(SessionID, notice, "Login", "Bad credentials, try again!"),
      {ok, login}
  end
;










login('GET', []) ->
  boss_flash:add(SessionID, notice, "Login", "Enter your password!"),
  {ok, login}.



logout('POST', []) ->

  boss_session:delete_session(SessionID),

  {action_other, [{controller, "base"}, {action, "index"}]}

.