-module(training_filter).

-export([before_filter/2]).

before_filter(_FilterConfig, RequestContext) ->
  SessionId = proplists:get_value(session_id, RequestContext),
%%   Request = proplists:get_value(request, RequestContext),
  lager:log(info, self(), " before filter invoked", []),
  Action = proplists:get_value(action, RequestContext),
  case boss_session:get_session_data(SessionId, username) of
    undefined when Action == "login" ->
      boss_session:set_session_data(SessionId, original_request_context, RequestContext),
      {ok, RequestContext};
    undefined ->
      lager:log(error, self(), " failed to grab user from session/RequestContext ~p", [RequestContext]),
      boss_session:set_session_data(SessionId, original_request_context, RequestContext),
      {redirect, "/login"};
    _Username ->
      {ok, RequestContext}
  end.