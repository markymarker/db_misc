#!/bin/bash
# Author: Mark Fletcher

print_help(){
  printf '
  usage: %s <directory>

  Where <directory> is the directory containing the schema set to compile.
  The schemas should be defined by named folders under the given directory.
  Each schema folder should contain table definition files along with a file
  named "_foreign_keys.sql" that contains the foreign key definitions (optional).

  All of the related definition files will be concatenated together along with
  relevant surrounding operations and sent to stdout.

' "$0"

  exit 4
}


# Must provide argument of directory
[ -d "$1" ] || print_help
cd "$1" || exit 1

schema_dirs=( */ )
schemas="$(sed 's/ /,/g;s-/--g' <<<"${schema_dirs[*]}")"
foreign_keys=''


# Print header info and global commands
printf -- '-- Schemas: %s
-- Generated: %s

-- BEGIN;

-- (TODO: things from db_user.sql)

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

\n\n' "$schemas" "$(date +%F)"


# Go through schema subdirectories
for schema in "${schema_dirs[@]}"; do
  schema="${schema%/}"
  printf -- '
-- -----------------------------------------------------
-- Schema "%s"
-- -----------------------------------------------------
' "$schema"
  printf 'CREATE SCHEMA IF NOT EXISTS "%s";\n' "$schema"
  printf 'SET search_path TO %s, public;\n\n' "$schema"
  printf 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";\n\n\n'

  # Go through table definitions in schema
  for table in "$schema"/*.sql; do
    # Special handling of _foreign_keys.sql file
    if [ "${table##*/}" = "_foreign_keys.sql" ]; then
      printf -v foreign_keys '%s
-- -----------------------------------------------------
-- Foreign Keys for "%s"
-- -----------------------------------------------------

%s\n\n' "$foreign_keys" "$schema" "$(<$table)"
      continue
    fi

    cat "$table"
    printf '\n'
  done

  printf '\n'
done


# Print foreign keys and footer commands
printf '\n
-- -----------------------------------------------------
-- Foreign Keys
-- -----------------------------------------------------
SET search_path TO %s;\n' "$schemas"
printf '%s\n\n' "$foreign_keys"


# Add grants for dbuser
printf '\n
-- -----------------------------------------------------
-- Grants
-- -----------------------------------------------------
GRANT USAGE ON SCHEMA %s TO dbuser;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA %s TO dbuser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA %s to dbuser;\n' "$schemas" "$schemas" "$schemas"

printf '\n\nSET search_path TO DEFAULT;\n'

