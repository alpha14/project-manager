fs = require 'fs'
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project, files) ->

    projectName = project.name
    console.log "Creating the header file #{projectName}.h ...".blue

    list = []
    regex = /(.*)\t(.*)[(](.*)[)]/g
    for file in files
        if file.substring(file.length - 2, file.length) is '.c'
            console.log file
            rawContent = fs.readFileSync file, 'utf8'
            content = rawContent.split '\n'
            for value in content
                if regex.test(value) and not ~value.indexOf("\tmain(")
                    list.push value
    #
    # Todo: check for list = 0
    #
    data = lib.commentHeader(project, path)

    data += "#ifndef #{projectName.toUpperCase()}_H_" +
    "\n# define #{projectName.toUpperCase()}_H_\n\n"

    for item in list
        data += "#{item};\n"
    data += "\n#endif /* !#{projectName.toUpperCase()}_H_ */"

    fs.writeFile path + '/' + "#{projectName}.h", data, (err) ->
        if err?
            console.error err.red
        else
            console.log 'file saved'.blue
