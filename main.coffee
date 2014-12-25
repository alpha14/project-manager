#!/usr/bin/env coffee

program = require 'commander'
moment = require 'moment'
fs = require 'fs'
recursive = require 'recursive-readdir'
colors = require 'colors'
pkg = require './package.json'
version = pkg.version
makefile = require './makefile'
genProject = require './genproject'
header = require './header'
path = process.cwd()

parseFile = (callback) ->

    if fs.existsSync(path + '/' + '.project')
        rawData =  fs.readFileSync path + '/' + '.project'
        try
            project = JSON.parse rawData
        catch error
            err = 'Error while parsing .project file'
            callback err
        if not project.mail?
            project['mail'] = "#{project.login}@epitech.eu"
        if project.name? and project.binary? and project.login?
            callback null, project
        else
            err = 'Error : Missing data in .project'
            callback err
    else
        err = 'Error: project file not found'
        callback err

program
   .version(version)
   .usage('<command> [<args>]')

program
    .command("new")
    .description("Create a new project")
    .action () ->
        genProject.parseInput()

program
    .command("makefile")
    .description("Generate Makefile")
    .action ->
        parseFile (err, project) ->
            if err?
                console.error err.red
            else
                recursive path, (err, files) ->
                    if err?
                        console.error err.red
                    else
                        makefile(project, files)

program
    .command("header")
    .description("Generate header file")
    .action ->
        parseFile (err, project) ->
            if err?
                console.error err.red
            else
                recursive path, (err, files) ->
                    if err?
                        console.error err.red
                    else
                        header(project, files)
# program
#    .command("replace <arg1> <arg2> <path>")
#    .description("Bleh")
#    .action (arg1, arg2, path) ->
#         console.log
#         replace(arg1, arg2, path)

program
   .command("*")
   .description("unknown command")
   .action ->
        console.log "Unknown command see #{process.argv[1].split('/').pop()} --help"

program.parse process.argv

if program.args.length is 0
    program.help()
#end
