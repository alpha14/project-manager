#!/usr/bin/env coffee

program = require 'commander'
moment = require 'moment'
fs = require "fs"
colors = require 'colors'
pkg = require './package.json'
version = pkg.version
makefile = require './makefile'
path = process.cwd()

program
   .version(version)
   .usage('<action> <app>')

program
    .command("makefile")
    .action ->
        makefile()

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
        console.log 'Unknown command'

program.parse process.argv
#end
