recursive = require 'recursive-readdir'
moment = require 'moment'
fs = require "fs"
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project) ->

    # Todo:
    # CFLAGS with include and LDFLAGS
    login = project.login or process.env.LOGNAME or process.env.USER
    projectName = project.name
    binaryName = project.binary
    mail = "#{login}@epitech.eu"
    console.log "building makefile...".blue
    # Retrieve all files in the directory
    recursive path, (err, files) ->

        list = []
        # Pick only C files
        for file in files
            if file.substring(file.length - 2, file.length) is '.c'
                list.push file

        # If no C file was found
        if list.length is 0
            console.log 'error : No C files found in directory'.red
            return

        # Adding header
        data = lib.commentHeader(projectName, path, login, mail)

        data += "CC\t=\tcc\n\nNAME\t=\t#{binaryName}\n\nSRC\t=\t"

        # Inserting C files
        for file, i in list
            if i isnt 0 then data += '\n\t\t'
            data += file.substring(path.length + 1, file.length)
            if i isnt list.length-1 then data += ' \\'

        # Adding the rest of the makefile
        data += "\n\nOBJ\t=\t$(SRC:.c=.o)\n\nall:\t\t$(NAME)\n\n$(NAME):\t$(" +
        "SRC)\n\t\t$(CC) -o $(NAME) $(SRC)\n\nclean:\t\trm -rf $(SRC)\n\nfcl" +
        "ean:\t\tclean\n\t\trm -rf $(NAME)\n\nre:\t\tfclean all\n\n.PHONY:\t" +
        "\tall clean fclean re\n"

        # Write the file
        fs.writeFile path + '/Makefile', data, (err) ->
            if err?
                console.log err.red
            else
                console.log 'file saved'.blue
