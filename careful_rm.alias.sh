#######################################################################
#              careful_rm aliases for sh, bash, and zsh               #
#######################################################################

# Get PATH to the careful_rm.py python script, works with sh, bash, zsh,
# and dash
if [ -n "${ZSH_VERSION}" ]; then
    SOURCE="$0:A"
elif [ -n "${BASH_SOURCE}" ]; then
    SOURCE="${BASH_SOURCE}"
elif [ -f "$0" ]; then
    SOURCE="$0"
else
    SOURCE="$_"
fi

# resolve $SOURCE until the file is no longer a symlink
while [[ -h "$SOURCE" ]]; do
  echo "Is Symlink"
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the
  # path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
CAREFUL_RM_DIR="$(dirname "$SOURCE")"

# Try to use our version first
CAREFUL_RM_SCRIPT="${CAREFUL_RM_DIR}/careful_rm.py"
_PY=$(which python)

# Set the aliases
if [[ -e "${CAREFUL_RM_SCRIPT}" ]]; then
    alias rm="${_PY} ${CAREFUL_RM_SCRIPT}"
    # Alias careful_rm if it isn't installed via pip already
    if ! hash careful_rm 2>/dev/null; then
        alias careful_rm="${_PY} ${CAREFUL_RM_SCRIPT}"
    fi
    alias trash_dir="${_PY} ${CAREFUL_RM} --get-trash \${PWD}"
else
    echo "careful_rm.py is not available, using regular rm"
    alias rm="rm -I"
fi

unset _PY _USE_PIP _pth _pos_paths _pyver
export CAREFUL_RM_SCRIPT CAREFUL_RM_DIR
