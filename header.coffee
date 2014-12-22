recursive = require 'recursive-readdir'
fs = require "fs"
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project) ->

    login = project.login or process.env.LOGNAME or process.env.USER
    projectName = project.name
    mail = "#{login}@epitech.eu"
    console.log "Creating the file #{projectName}.h ...".blue

    data = lib.commentHeader(projectName, path, login, mail)

    data += "\n#ifndef _#{projectName}_H_"
    data += "\n# define _#{projectName}_H_"
    data += "\n"
    data += "\n#endif /* !_#{projectName}_H_ */"

    fs.writeFile path + "/#{projectName}.h", data, (err) ->
        if err?
            console.log err.red
        else
            console.log 'file saved'.blue
