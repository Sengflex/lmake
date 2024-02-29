
local lfs=require'lfs'

function LastModification(filePath)
    return lfs.attributes(filePath, 'modification')
end

function FileIsNewerThan(filePath, baseDate)
    local fileModification=LastModification(filePath)
    return fileModification > baseDate
end

function FileExists(filePath)
    local ret=false
    local f=io.open(filePath, 'r')
    if f then
        f:close()
        ret=true
    end
    return ret
end