#!/bin/zsh

VENVS_PATH="$HOME/.venvs"

_RED='\033[91m'
_GREEN='\033[92m'
_YELLOW='\033[93m'
_BOLD='\033[1m'
_UNDERLINE='\033[4m'
_END='\033[0m'


_error(){
    error_msg=$1
    echo -e ${_RED}${error_msg}${END}
}


_common::str_split(){
    string=$1
    index=$2
    sep=$3
    if [ -z $sep ]; then
        sep=' '
    fi
    set +e
    res=$(python -c "print('$string'.split('$sep')[$index])")
    if [ $? -ne 0 ]; then
        _error "Failed to split str: $string, $index, $sep"
        set -e
        return 1
    fi
    set -e
    echo $res
}

_common::list_dirs(){
    parent_dir=$1
    python -c "from pathlib import Path;print(' '.join([str(child) for child in Path('$parent_dir').iterdir() if child.is_dir()]))"
}


_venv::gen(){
    if [ ! -z $VIRTUAL_ENV ];then
        OLD_ENV=$VIRTUAL_ENV
        _venv::deactivate
    fi
    venv_name=$1
    venv_python=$2
    if [ -z $venv_python ]; then
        venv_python=$(which python)
    fi
    if [[ -d $VENVS_PATH/$venv_name ]]; then
        _error "Dir $VENVS_PATH/$venv_name exists"
        return 1
    fi
    virtualenv $VENVS_PATH/$venv_name -p $venv_python
    if [ $? -ne 0 ];then
        return 1
    fi
    if [ $3 = "-r" ] && [ ! -z $4 ]; then
        _venv::activate $venv_name
        cat $4 | while read line
        do
            eval "pip install $line"
        done
    fi

    _venv::desc $venv_name

    if [ ! -z $OLD_ENV ]; then
        source $OLD_ENV/bin/activate
    fi

}


_venv::remove(){
    venv_name=$1
    if [[ ! -d $VENVS_PATH/$venv_name ]]; then
        _error "Dir $VENVS_PATH/$venv_name not exists"
        return 1
    fi
    rm -rf $VENVS_PATH/$venv_name
    rm -f $VENVS_PATH/$venv_name.venv
    echo Remove $venv_name success
}


_venv::list(){
	printf '%-20s %-50s\n' VENV PATH
	venv_dirs=$(_common::list_dirs $VENVS_PATH)
	if [ -z $venv_dirs ] || [ $venv_dirs = "\n" ] || [ $venv_dirs = " " ];then
	    echo
	    return 0
	fi

	for venv_dir in $(echo $venv_dirs);
	do
		venv_name=$(_common::str_split $venv_dir -1 /)
		printf '%-20s %-30s\n' ${venv_name} ${venv_dir}
	done
}


_venv::activate () {
	venv_name=$1
	if [[ -z $venv_name ]]; then
	    _error "Venv name is Empty"
        return 1
    fi
    if [[ ! -d $VENVS_PATH/$venv_name ]]; then
        _error "Dir $VENVS_PATH/$venv_name not exists"
        return 1
    fi
	source $VENVS_PATH/$venv_name/bin/activate
}


_venv::deactivate() {
    deactivate
}


_venv::desc() {
	venv_name=$1
	if [[ -z $venv_name ]]; then
	    _error "Venv name is Empty"
        return 1
    fi
    if [[ ! -d $VENVS_PATH/$venv_name ]]; then
        _error "Dir $VENVS_PATH/$venv_name not exists"
        return 1
    fi

    py_exec=$VENVS_PATH/$venv_name/bin/python
    pip_exec=$VENVS_PATH/$venv_name/bin/pip
    echo Name: $venv_name
    echo Python: $($py_exec -V)
    echo Location: $VENVS_PATH/$venv_name
    echo Activate: venv activate $venv_name
    packeages=$($pip_exec freeze --local | xargs echo)
    if [ -z $packeages ] || [ "$packeages" = "\n" ] || [ "$packages" = " " ]; then
        echo Packages: None
        return 0
    fi
    echo Packages: $(python -c "print('$packeages'.replace(' ', ', '))")
}


venv() {
    if [ ! -d $VENVS_PATH ];then
        mkdir -p $VENVS_PATH
        echo Create venvs root path: $VENVS_PATH
    fi
    case $1 in
    "gen" )
        shift
        _venv::gen $@
        ;;
    "remove" )
        shift
        _venv::remove $@
        ;;
    "activate" )
        shift
        _venv::activate $@
        ;;
    "deactivate" )
        shift
        _venv::deactivate $@
        ;;

    "desc" )
        shift
        _venv::desc $@
        ;;
    "list" )
        shift
        _venv::list
        ;;
    *)
        echo "Usage: venv\n"
        echo "Management Commands:"
        printf "%-10s %-30s\n" gen "Generate venv: gen VENV_NAME PYTHON_EXECUTABLE -r REQUIREMENTS.txt"
        printf "%-10s %-30s\n" remove "Remove venv: remove VENV_NAME"
        printf "%-10s %-30s\n" desc "Show details of venv: desc VENV_NAME"
        printf "%-10s %-30s\n" list "List all venvs: list"
        printf "%-10s %-30s\n" activate "Activate venv: activate VENV_NAME"
        printf "%-10s %-30s\n" deactivate "Deactivate working venv: deactivate"
        ;;
    esac
}