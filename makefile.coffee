fs = require "fs"
colors = require 'colors'
lib = require './lib'
path = process.cwd()

module.exports = (project, files) ->

    login = project.login
    projectName = project.name
    binaryName = project.binary
    CFLAGS = project.CFLAGS
    LDFLAGS = project.LDFLAGS

    console.log "Building makefile...".blue

    list = []
    # Retrieve only C files
    for file in files
        if file.substring(file.length - 2, file.length) is '.c'
            list.push file

    # If no C file was found
    if list.length is 0
        console.log 'No C files found in directory'
        return

    # Adding header
    data = lib.commentHeader(project, path, "Makefile")

    data += "CC\t=\tcc\n\n"
    data += "NAME\t=\t#{binaryName}\n\n"

    if CFLAGS? and CFLAGS isnt ""
        data += "CFLAGS\t=\t#{CFLAGS}\n\n"

    if LDFLAGS? and LDFLAGS isnt ""
        data += "LDFLAGS\t=\t#{LDFLAGS}\n\n"

    data += "SRC\t=\t"

    # Inserting C files
    for file, i in list
        if i isnt 0 then data += '\n\t\t'
        data += file.substring(path.length + 1, file.length)
        if i isnt list.length - 1 then data += ' \\'

    # Adding the rest of the makefile
    data += "\n\nOBJ\t=\t$(SRC:.c=.o)\n\n" +
    "all:\t\t$(NAME)\n\n" +
    "$(NAME):\t$(OBJ)\n" +
    "\t\t$(CC) -o $(NAME) $(SRC) "
    if LDFLAGS and LDFLAGS isnt '' then data += "$(LDFLAGS)"
    data += "\n\n" +
    "clean:\n\t\trm -rf $(OBJ)\n\n" +
    "fclean:\t\tclean\n" +
    "\t\trm -rf $(NAME)\n\n" +
    "re:\t\tfclean all\n\n" +
    ".PHONY:\t\tall clean fclean re\n"

    # Write the file
    fs.writeFile path + '/Makefile', data, (err) ->
        if err?
            console.error err.red
        else
            console.log 'file saved'.blue
