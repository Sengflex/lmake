
--package.path=[[C:\Users\User\Portable\Luarocks\systree\share\lua\5.2\?.lua;C:\Users\User\Portable\Luarocks\systree\share\lua\5.2\?\init.lua;]]..package.path
--package.cpath=[[C:\Users\User\Portable\Luarocks\systree\lib\lua\5.2\?.dll]]..package.cpath

local lfs=require'lfs'
require'lmake.util'
local RulesTable=require'lmake.rule'
local RulesEnv=require'lmake.ruleenv'

local ARulesFile=args and (args[1] or 'makefile.lua') or 'makefile.lua'
local ARuleToProcess=args and (args[2] or ':first:') or ':first:'

RulesEnv:load(ARulesFile)

local ruleDef

if ARuleToProcess==':first:' then
    ruleDef=RulesTable[1]
else
    ruleDef=RulesTable:findTarget(ARuleToProcess)
end

if not ruleDef then
    error('Invalid rule')
end

RulesTable:processRule(ruleDef)
