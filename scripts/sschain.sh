#!/bin/bash
# ssh name@host -At name@host -At

function main()
{
	for VAR in $@; do
		echo $VAR
	donei
}
main "$@"
