#!/bin/bash -e

SELF=${0}
SOURCE_DIR=$(dirname $(readlink -f ${SELF}))
#============================================FUNCTIONS==============================================
usage()
{
  err_echo "$SELF is a tool to read a file and generate output based on the letter frequency and distribution of the input file
-----------------------------------------------------------------------bch
USAGE: $SELF -i FILENAME [-n NUMBER]
  -i     # the input filename
  -n     # number of lines to print [default 1]
"
  err_echo $*
  exit 1
}

err_echo()
{
  echo "$@" 1>&2
}


verify_dependencies()
{	
  for REQUIRED_FILE in ${REQUIRED_FILES}; do
    if [ ! -f ${SOURCE_DIR}/${REQUIRED_FILE} ]; then
      usage "${SELF##*/} requires a missing file, ${REQUIRED_FILE}, to run,
Please add ${REQUIRED_FILE} to ${SOURCE_DIR} to continue"
    fi
  done
}

process_arguments()
{
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help)
        usage
      ;;
      -i|-I)
        if [ -z "$2" ]; then
          usage "Improper number of arguments supplied for INPUT_FILE flag (-i)"
        fi
        INPUT_FILE=$2
        shift
      ;;
      -n|-N)
        if [ -z "$2" ]; then
          usage "Improper number of arguments supplied for NUMBER flag (-n)"
        fi
        case "$2" in
          ''|*[!0-9]*)
            usage "Improper format supplied for NUMBER flag (-n) expected a number, not $2"
          ;;
          *)
            NUMBER_OUT=$2
          ;;
        esac
        shift
      ;;
      -p|-P)
        if [ -z "$2" ]; then
          usage "Improper number of arguments supplied for PREVIOUS_ANALYSIS flag (-p)"
        fi
        PREVIOUS_ANALYSIS=true
        PREVIOUS_ANALYSIS_FILE="$2"
        shift
      ;;
    esac
    shift
  done

  FILE_LIST="INPUT_FILE"
  if [ "${PREVIOUS_ANALYSIS}" = true ]; then
    FILE_LIST="${FILE_LIST} PREVIOUS_ANALYSIS_FILE"
  fi

  for CHECK_FILE in ${FILE_LIST}; do
    if [ -z "${!CHECK_FILE}" ]; then
      usage "NO ${CHECK_FILE} specified"
    fi
    if [ ! -f "${!CHECK_FILE}" ]; then
      usage "FILE ${!CHECK_FILE} doesn't exist"
    fi
    if [ ! -s "${!CHECK_FILE}" ]; then 
      usage "FILE ${!CHECK_FILE} is empty."
    fi
    FILE_TYPE=$(file -b --mime ${!CHECK_FILE})
    case "${FILE_TYPE}" in
      text/plain*)
        DO_NOTHING=DO_NOTHING
      ;;
      *binary)
        usage "FILE ${!CHECK_FILE} is binary and unable to be used by ${SELF}"
      ;;
    esac
  done

  REQUIRED_FILES="count_file_contents"
  if [ -n "${REQUIRED_FILES}" ]; then
    verify_dependencies 
  fi
}
#==========================================END FUNCTIONS============================================
if [ -z "${WORKSPACE}" ]; then
  WORKSPACE=$(pwd)
fi

INPUT_FILE=""
NUMBER_OUT="1"
PREVIOUS_ANALYSIS="FALSE"
PREVIOUS_ANALYSIS_FILE=""

if [ $# -lt 1 ]; then
  usage "No arguments specified"
fi

process_arguments "$@"

./count_file_contents ${INPUT_FILE}
