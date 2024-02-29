require'lmake.util'

local RulesTable={msgLevel=0, levelStep='    '}
RulesTable.findTarget=function(self, tgtName)
    for _, def in ipairs(self) do
        if def.target == tgtName then
            return def
        end
    end
    return nil
end
RulesTable.print=function(self, msg)
    local levelSpaces=''
    for i = 1, self.msgLevel do
        levelSpaces=levelSpaces..self.levelStep
    end
    print(levelSpaces..msg)
end
RulesTable.enterLevel=function(self)
    self.msgLevel=self.msgLevel+1
end
RulesTable.outLevel=function(self)
    self.msgLevel=self.msgLevel-1
    if self.msgLevel < 0 then
        self.msgLevel = 1
    end
end
RulesTable.processRule=function(self, ruleDef)
    self:print('::processing:: '..ruleDef.target)
    self:enterLevel()
    if type(ruleDef.deps)=='table' then
        for _, dep in ipairs(ruleDef.deps) do
            --Check if dependency has it own rules and process it
            self:print('::dependency found::')
            local depDef=RulesTable:findTarget(dep)
            if depDef then
                self:processRule(depDef)
            else
              self:print('::dependency has no rule:: '..dep)
            end
        end
    end
    for _, action in ipairs(ruleDef.actions) do
        local requiresTgtUpdate=false
        local targetExists=FileExists(ruleDef.target)
        if (type(ruleDef.deps)=='table') and targetExists then
            local tgtModification=LastModification(ruleDef.target)
            for _, dep in ipairs(ruleDef.deps) do
                if FileIsNewerThan(dep, tgtModification) then
                    requiresTgtUpdate=true
                    break
                end
            end
        else
            -- No deps. Check if file exists
            requiresTgtUpdate=not targetExists
        end
        if requiresTgtUpdate then
            self:print('::Action:: ')
            action(ruleDef.target, ruleDef.deps)
        else
            self:print('::up to date:: ')
        end
    end
    self:outLevel()
    return true
end

return RulesTable
