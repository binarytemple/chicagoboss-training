# chicagoboss-training
chicagoboss-training


Inserting chat messages from the command line

```
(training@catah)9> Chat = chat:new(id, "asdads", "2015-04-04T00:00:00").
{chat,id,"asdads","2015-04-04T00:00:00"}

(training@catah)11> Chat:save().
23:09:35.340 [info] Query INSERT INTO chats (`created`, `message`) values ('2015-04-04T00:00:00', 'asdads')
23:09:35.347 [info] Query SELECT last_insert_id()
{ok,{chat,"chat-3","asdads","2015-04-04T00:00:00"}}

```
