
rule{
    target='out_file.txt',
    deps={
        'in_file.txt',
        'in_file2.txt'
    },
    actions={
        actions.ConcatenateFiles
    }
}

rule{
    target='in_file.txt',
    actions={
        function(target, deps)
            local targetContent='Some content'    
            local outFile=io.open(target, 'w')
            outFile:write(targetContent)
            outFile:close()
            return true
        end
    }
}