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

        defaultCflags = '-W -Werror -Wall -Wextra -ansi -pedantic -I .'
        defaultName = __dirname.split('/').pop()
        rl.question "Project name: (#{defaultName}) ", (name) =>

            rl.question "Binary name: (a.out) ", (binary) =>
                rl.question "CFLAGS: (#{defaultCflags}) ", (cflags) =>
                    rl.question "LDFLAGS: (none) ", (ldflags) =>

                        data =
                            name: if name is '' then defaultName else name
                            binary: if binary is '' then 'a.out' else binary
                            login: login
                            CFLAGS: if cflags is '' then defaultCflags else cflags
                            LDFLAGS: if ldflags is '' then '' else ldflags

                        fileData = JSON.stringify data, null, 2
                        console.log "\n" + fileData
                        rl.question '\n\nIs this ok? (yes) ', (answer) =>
                            rl.pause()
                            answers = ['', 'y', 'ye', 'yes']
                            if answer.toLowerCase() in answers
                                @createFile fileData
                            else
                                console.log 'Aborted'.red



    createFile: (fileData) ->

        fs.writeFile path + '/' + '.project', fileData, (err) ->
            if err?
                console.error err.red
            else
                console.log 'Project created'.green
