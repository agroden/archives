# setpyenv
# A simple function for easily setting python environments.
#
# Most people keep their Python virtual environments in a folder together, 
# like: "~/python-envs/".  This script will help set the current Python virtual 
# environment by simplifying the activation process.  Simply export PY_ENVS_DIR 
# to the folder you keep your Python virtual environments in and and source 
# this file in your .bashrc.  To activate a virtual environment, just type: 
# setpyenv <env_name>, where env_name is the name of the directory inside the 
# PY_ENVS_DIR of the virutal environment you wish to use.  The env_name arg 
# supports tab completion, as setpyenv builds a list of environments based on 
# directory names in your PY_ENVS_DIR.

setpyenv() {
	# ensure PY_ENVS_DIR is set
	if [ -z "$PY_ENVS_DIR" ]; then
		echo "PY_ENVS_DIR is not found, please export it before running this \
			command"
		return 1
	fi
	
	# deactivate the current virtual environment before we source the new one
	# ...this is probably unnecessary
	if [[ -n "$VIRTUAL_ENV" && "$PY_ENVS_DIR/$1" != "$VIRTUAL_ENV" ]]; then
		deactivate
	fi
	
	# source the activate script
	source "$PY_ENVS_DIR/$1/bin/activate"
	return 0
}

_setpyenv() {
	local cur envs
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	
	# grab a list of directory names in the PY_ENVS_DIR
	envs=`ls -l --time-style="long-iso" $PY_ENVS_DIR | egrep '^d' | awk '{print $8}'`
	
	# only complete one arg
	if [ $COMP_CWORD -lt 2 ]; then
		COMPREPLY=( $(compgen -W "${envs}" -- ${cur}) )
	fi
	return 0
}

complete -F _setpyenv setpyenv