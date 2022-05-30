#!/bin/sh
# A git pre-commit hook that verifies that the change does not introduce
# the use of a Jasmine exclusive test , which would
# prevent most other tests from being run without any clear indication thereof

 FILES_PATTERN='\.(js|coffee)(\..+)?$'
FORBIDDEN='fit('
git diff --cached --name-only | \
    grep -E $FILES_PATTERN | \
    GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n $FORBIDDEN && echo 'COMMIT REJECTED Found "$FORBIDDEN" references. Please remove them before commiting' && exit 1