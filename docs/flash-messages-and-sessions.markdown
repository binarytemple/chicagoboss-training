### TODOs

http://embed.plnkr.co/y1INk36bPbW7GaX15QbQ/index.html

Flash messages (view side):
```
+++ src/view/chatroom/console.html	(revision )
@@ -44,6 +44,9 @@
     </script>
 </head>
 <body>
+{% for flash in boss_flash %} {{ flash.method }} - {{ flash.title }} - {{ flash.message }} {% endfor %}
+
+
 <h2>Send:</h2>
```

Logging the SessionId from websocket controller:

```
+++ src/websocket/training_chat_protocol_websocket.erl	(revision )
@@ -50,7 +50,7 @@
   %% end,
 
   DecodedMessage = jsx:decode(Message),
-  lager:log(info, self(), "Message = ~p - ~p", [Message, DecodedMessage]),
+  lager:log(info, self(), "SessionId = ~p, Message = ~p - ~p", [SessionId, Message, DecodedMessage]),
 
   store_message(
     proplists:get_value(<<"user">>, DecodedMessage),
```

Modifying the websocket controler to support SessionID

```
+++ src/controller/training_chatroom_controller.erl	(revision )
@@ -1,26 +1,30 @@
--module(training_chatroom_controller, [Req]).
+-module(training_chatroom_controller, [Req,SessionID]).
 -compile(export_all).
```

Flash messages (controller modifications)

```
+++ src/controller/training_chatroom_controller.erl	(revision )
 console('GET', []) ->
+  boss_flash:add(SessionID, notice, "Flash Title", "Flash Message"),
+
+  %%boss_session:new_session("foo"),
+  boss_session:set_session_data( SessionID, "bar", "baz"),
-    lager:log(info, self(), "~p console", [ training_chatroom_controller ]),
+  lager:log(info, self(), "~p console", [training_chatroom_controller]),
-    {ok, [{user,uuid:to_string( uuid:uuid1() ) }]}.
+  {ok, [{user, uuid:to_string(uuid:uuid1())}]}.

Enabling sessions (chicagoboss configuration (boss.config))
```
--- boss.config	(revision 7e372f75f4775387855a795a13300315b5a2f7bf)
+++ boss.config	(revision )
@@ -203,12 +203,12 @@
 %%     (*.domain.com) with the param ".domain.com" => {session_domain,
 %%     ".domain.com"}
 
-    {session_adapter, mock},
+%%     {session_adapter, mock},
     {session_key, "_boss_session"},
     {session_exp_time, 525600},
     {session_cookie_http_only, false},
     {session_cookie_secure, false},
-%    {session_enable, true},
+    {session_enable, true},
 %    {session_mnesia_nodes, [node()]}, % <- replace "node()" with a node name
 %    {session_domain, ".domain.com"},
``` 
