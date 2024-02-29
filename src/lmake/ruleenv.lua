
local RulesTable=require'lmake.rule'

local RulesEnv={}

RulesEnv.string=string
RulesEnv.math=math
RulesEnv.table=table
RulesEnv.io={open=io.open}
RulesEnv.print=print
RulesEnv.ipairs=ipairs
RulesEnv.rule=function(ruleDef)
    RulesTable[#RulesTable+1]=ruleDef
end

RulesEnv.actions={
  ConcatenateFiles=function(target, deps)
      local targetContent=''            
      for _, dep in ipairs(deps) do
          local inFile=io.open(dep, 'r')
          if not inFile then
            error('Missing file: '..tostring(dep))
          end
          local tmpContent=inFile:read('*a')
          inFile:close()
          targetContent=targetContent..tmpContent
      end
      local outFile=io.open(target, 'w')
      outFile:write(targetContent)
      outFile:close()
      return true
  end
}

RulesEnv.load=function(self, ARulesFile)
  local loadedRules=loadfile(ARulesFile, "t", self)
  loadedRules()

  if #RulesTable < 1 then
      error('No rules to process')
  end
end

return RulesEnv

