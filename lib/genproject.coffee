require 'shelljs/global'
recursive = require 'recursive-readdir'
fs = require 'fs'
readline = require 'readline'
colors = require 'colors'
lib = require './lib'
path = process.cwd()
io =
    input: process.stdin,
    output: process.stdout

module.exports =

    parseInput: () ->

        rl = readline.createInterface io
        # Get login from env
        login = process.env.LOGIN or process.env.LOGNAME or process.env.USER

        defaultCflags = '-Werror -Wall -Wextra'
        # Name of the directory
        defaultName = path.split('/').pop()
        rl.question "Project name: (#{defaultName}) ", (name) =>
            rl.question "Binary name: (a.out) ", (binary) =>
                rl.question "Headers directory: (.) ", (include) =>
                    rl.question "CFlags: (#{defaultCflags}) ", (cflags) =>
                        rl.question "LDFlags: (none) ", (ldflags) =>

                            @ProjectLanguage rl, (lang) =>

                                data =
                                name: if name is '' then defaultName else name
                                binary: if binary is '' then 'a.out' else binary
                                login: login
                                lang: lang
                                include: if include is '' then '.' else include
                                cflags: if cflags is '' then defaultCflags else cflags
                                ldflags: ldflags

                                fileData = JSON.stringify data, null, 2
                                console.log "\n" + fileData
                                rl.question '\n\nIs this ok? (yes) ', (answer) =>
                                    answers = ['', 'y', 'ye', 'yes']
                                    rl.pause()
                                    if answer.toLowerCase() in answers
                                        @createFile fileData
                                        @deployFiles(data)
                                    else
                                        console.log 'Aborted'.red

    ProjectLanguage: (rl, callback) ->
        recursive path, (err, files) ->
            if err?
                console.error err.red
                process.exit 1
            else
                c = []
                cpp = []
                for file in files
                    if file.substring(file.length - 2, file.length) is '.c'
                        c.push file
                for file in files
                    if file.substring(file.length - 4, file.length) is '.cpp'
                        cpp.push file
                if c.length > 0 and cpp.length is 0
                    callback 'c'
                else if cpp.length > 0 and c.length is 0
                    callback 'cpp'
                else
                    console.log "Language not detected".yellow
                    rl.question ("Project language: (c or cpp): "), (lang) =>
                        answers = ['c', 'cpp', 'c++']
                        if lang.toLowerCase() in answers
                            lang = 'cpp' if lang is 'c++'
                            callback lang
                        else
                            console.error 'Fatal error : Project language unknown'.red
                            process.exit 1

    createFile: (fileData, cb) ->

        fs.writeFile path + '/' + '.project', fileData, (err) ->
            if err?
                console.error err.red
            else
                console.log 'Project created\n'.green

    deployFiles: (project) ->
        "#{project.login}\n".to('auteur');
        "#{project.binary}\n.project\n*.o\n*~\n".to('.gitignore');
