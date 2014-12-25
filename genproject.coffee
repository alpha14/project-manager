recursive = require 'recursive-readdir'
fs = require 'fs'
readline = require 'readline'
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports =

    parseInput: () ->

        # Get login from env
        login = process.env.LOGIN or process.env.LOGNAME or process.env.USER

        io =
            input: process.stdin,
            output: process.stdout
        rl = readline.createInterface io

        defaultName = __dirname.split('/').pop()
        rl.question "Project name (default #{defaultName}) ?", (name) =>

            rl.question "Binary name (default a.out) ?", (binary) =>
                rl.close()
                if name is '' then name = defaultName
                if binary is '' then binary = 'a.out'
                data =
                    name: name
                    binary: binary
                    login: login
                    LDFLAGS: ''
                    CFLAGS: '-I./'
                fileData = JSON.stringify data
                @createFile fileData

    createFile: (data) ->

        if fs.existsSync(path + '/' + '.project')
            console.error 'Project already existing'
        else
            console.log 'Generating project...'


            fs.writeFile path + '/' + '.project', data, (err) ->
                if err?
                    console.error err.red
                else
                    console.log 'Project created'
