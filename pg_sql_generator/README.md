## Generator script to aid in working with DDL in an organized fashion

`generator.sh` is a script to produce a single, consolidated file of SQL output from an input of multiple files and directories. The input files are organized into a hierarchy of schemas and tables to help maintain some sanity while working on the definitions for a large project.

Hopefully I will fill this out more in the future. For now though, the script itself includes a help block that should give some idea of what's going on. In addition, "sample_ddl_dir" contains an example structure to illustrate how things are meant to be organized.

The script does not modify the input files and writes its output to stdout. It can be invoked on the sample dir as so: `./generator.sh sample_ddl_dir`.

There is room for improvement on the way the script handles some things, namely the accumulating of foreign keys, but the script in its current form has worked without issue on a project with over 42,000 characters worth of foreign key output, so... works on my machine.


## Anticipated FAQ

Q: Why not just use some kind of visual workbench software?  
A: I encourage you to do what makes sense for your project.

