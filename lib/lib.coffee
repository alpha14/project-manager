moment = require 'moment'

module.exports =

    commentHeader: (project, path, file_name, extension) ->

        now = moment()
        dateFormat = 'ddd MMM D HH:mm:ss YYYY'

        if (extension is '.h' or extension is '.c')
            C_START = "/*"
            C_MID = "**"
            C_END = "*/"
        else
            C_START = "##"
            C_MID = "##"
            C_END = "##"

        data = "#{C_START}\n" +
        "#{C_MID} #{file_name} for #{project.name} in #{path}\n" +
        "#{C_MID}\n" +
        "#{C_MID} Made by #{project.login}\n" +
        "#{C_MID} Login   <#{project.mail}>\n" +
        "#{C_MID}\n" +
        "#{C_MID} Started on  #{now.format(dateFormat)} #{project.login}\n" +
        "#{C_MID} Last update #{now.format(dateFormat)} #{project.login}\n" +
        "#{C_END}\n\n"

        return data
