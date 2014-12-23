fs = require "fs"
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project, files) ->

    projectName = project.name
    console.log "Creating the header file #{projectName}.h ...".blue

    data = lib.commentHeader(project, path)

    data += "#ifndef _#{projectName}_H_" +
    "\n# define _#{projectName}_H_" +
    "\n" +
    "\n#endif /* !_#{projectName}_H_ */"

    fs.writeFile path + '/' + "#{projectName}.h", data, (err) ->
        if err?
            console.log err.red
        else
            console.log 'file saved'.blue
