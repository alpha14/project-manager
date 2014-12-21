#!/usr/bin/env coffee

program = require 'commander'
moment = require 'moment'
fs = require "fs"
colors = require 'colors'
pkg = require './package.json'
version = pkg.version
makefile = require './makefile'
path = process.cwd()

genProject = (name, binaryName) ->

    if fs.existsSync(path + '/' + '.project')
        console.error 'Project already existing'
    else
        console.log 'Generating project...'
        data =
            name: name
            binary: binaryName

        fileData = JSON.stringify data
        fs.writeFile path + '/' + '.project', fileData, (err) ->
            if err?
                console.error err.red
            else
                console.log 'Project created'

parseFile = (callback) ->
    if fs.existsSync(path + '/' + '.project')
        rawData =  fs.readFileSync path + '/' + '.project'
        try
            project = JSON.parse rawData
        catch error
            console.error 'Error while parsing .project file'
        if project.name? and project.binary?
            callback project
        else
            console.error 'Error : project and binary names are mandatory'.red
            callback null
    else
        console.error 'Error: project file not found'.red
        callback null

program
   .version(version)
   .usage('<command> [<args>]')

program
    .command("new [name] [binaryName]")
    .description("Create a new project")
    .action (name, binaryName) ->
        if name? and binaryName?
            genProject name, binaryName
        else
            console.error 'Not enough arguments'
            console.error 'prompt not implemented yet'


program
    .command("makefile")
    .description("Generate Makefile")
    .action ->
        parseFile (project) ->
            if project?
                makefile(project)


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
