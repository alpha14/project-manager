moment = require 'moment'

module.exports =

    commentHeader: (project, path) ->
        now = moment()

        data = "##\n## Makefile for #{project.name} in #{path}\n" +
        "##\n" +
        "## Made by #{project.login}\n" +
        "## Login   <#{project.mail}>\n" +
        "##\n## Started on  #{now.format("MMM D hh:mm:ss YYYY")} #{project.login}\n" +
        "## Last update #{now.format("MMM D hh:mm:ss YYYY")} #{project.login}\n" +
        "##\n\n"

        return data
