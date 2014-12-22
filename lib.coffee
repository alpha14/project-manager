moment = require 'moment'

module.exports =

    commentHeader: (projectName, path, login, mail) ->
        now = moment()
        data = "##\n## Makefile for #{projectName} in #{path}\n" +
        "##\n" +
        "## Made by #{login}\n" +
        "## Login   <#{mail}>\n" +
        "##\n## Started on  #{now.format("MMM D hh:mm:ss YYYY")} #{login}\n" +
        "## Last update #{now.format("MMM D hh:mm:ss YYYY")} #{login}\n" +
        "##\n\n"

        return data
