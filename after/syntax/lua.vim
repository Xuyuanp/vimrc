scriptencoding utf-8

syntax match LuaLambda /\mfunction(/me=s+8 containedin=ALL conceal cchar=ﬦ

hi! link Conceal luaFunction

setlocal conceallevel=1
setlocal concealcursor=nc
