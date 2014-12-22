recursive = require 'recursive-readdir'
fs = require "fs"
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (name, binaryName) ->

    login = process.env.LOGIN or process.env.LOGNAME or process.env.USER

    if fs.existsSync(path + '/' + '.project')
        console.error 'Project already existing'
    else
        console.log 'Generating project...'

        data =
            name: name
            binary: binaryName
            login: login

        fileData = JSON.stringify data
        fs.writeFile path + '/' + '.project', fileData, (err) ->
            if err?
                console.error err.red
            else
                console.log 'Project created'
