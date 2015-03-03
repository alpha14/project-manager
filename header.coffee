fs = require 'fs'
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project, files) ->

    projectName = project.name
    lang = project.lang

    if lang is 'c'
        ext = 'h'
    if lang is 'cpp'
        ext = 'hpp'

    console.log "Creating the header file #{projectName}.#{ext} ...".blue
    list = []
    regex = /.*\t.*\(.*\)/g
    for file in files
        if file.substring(file.length - (lang.length + 1), file.length) is '.' + lang
            rawContent = fs.readFileSync file, 'utf8'
            content = rawContent.split '\n'
            for value in content
                if regex.test(value) and value not in list and not ~value.indexOf("\tmain(")
                    list.push value

    if list.length is 0
        console.error 'No functions found in the directory'

    data = lib.commentHeader(project, path, "#{projectName}.#{ext}", '.h')

    data += "#ifndef #{projectName.toUpperCase()}_#{ext.toUpperCase()}_" +
    "\n\n# define #{projectName.toUpperCase()}_#{ext.toUpperCase()}_\n\n"

    for item in list
        data += "#{item};\n"
    data += "\n#endif /* !#{projectName.toUpperCase()}_#{ext.toUpperCase()}_ */"

    fs.writeFile path + '/' + "#{projectName}.#{ext}", data, (err) ->
        if err?
            console.error err.red
            process.exit 1
        else
            console.log 'file saved'.blue
            process.exit 0
