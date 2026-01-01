#!/usr/bin/env bash

# get configs in place
python=(`which python3`) #this is a hack, should be grab python
name=(`basename "$PWD"`)

# parsing args first

POSITIONAL_ARGS=()
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--force)
      FORCE=true
      shift # past argument
      ;;
    -n|--name)
      name="$2"
      shift # past argument
      shift # past value
      ;;
    -q|--quiet)
      QUIET=true
      shift # past argument
      ;;
    -v|--verbose)
      VERBOSE=true
      shift # past argument
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

# Args parsed, let's check if diorectory exists or we can force it 

if [ -d $name ] && [ "$FORCE" = false ]; then
    echo "A directory named $name already exists. For safety I will not override it unless you run this program with -f argument (--force)."
    exit 1;
fi

# Cleared, let's create the virtual environment

## Create the environement
if $python -m venv $name; then 
    if [ ! "$QUIET" ]; then
        if [ "$VERBOSE" ]; then
            echo "Executed: $python -m venv $name"
	fi
        echo "Created a virtual environment named $name with python `$python --version`."
    fi
else
	echo "ERROR: Failed to create a virtual environment named $name with python `$python --version`."
fi

## Activate the environment
##  Note: sadly this is not as easy as "source $PWD/$name/bin/activate"
##        this is due to the fact that we need to create a new shell
##        and run the source in that new shell, not in the current shell!

if [ ! "$QUIET" ]; then
    if [ "$VERBOSE" ]; then
	echo "Will execute: source $name/bin/activate (in a new shell—the result will only be displayed after this message)."
    fi
	echo "Your virtual environment called $name will be activated. You can exit it with the deactivate command (which is just an alias to the exit command  and closes this sub-shell)."
fi

bash -c "source $PWD/$name/bin/activate; exec bash --init-file <(echo \"alias deactivate='exit'\")"
	
# Special credit to 
#   https://serverfault.com/questions/368054/run-an-interactive-bash-subshell-with-initial-commands-without-returning-to-the
#   for a solution regarding a new shell with a initial command

