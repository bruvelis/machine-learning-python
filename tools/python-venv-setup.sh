#!/usr/bin/env bash
# Copyright (C) 2017 Martins Bruvelis <martins.bruvelis@gmail.com>
# Distributed under the GNU General Public License, version 3.0.
#
# Name: Python venv setup
# Version: 1.0.0
# Description:  Bootstrapping script that enables users to download and install
# latest Python 3.6 using Miniconda and setup venv with Python libraries
# jupyter, pandas, keras, sklearn, seaborn tensorflow/tensorflow-gpu, etc.

# setup script configuration values
THIS_DIR=$(cd $(dirname $0); pwd)
THIS_FILE=$(basename $0)
THIS_PATH="$THIS_DIR/$THIS_FILE"
BATCH=0
TF_GPU=""
TF="tensorflow$TF_GPU"
MC_LATEST="Miniconda3-latest-Linux-x86_64.sh"
MC_URL="https://repo.continuum.io/miniconda/$MC_LATEST"
MC_PREFIX="$HOME/miniconda3"
MC_REUSE=0
VENV_PREFIX="$HOME/venv/$TF"
PYTHON_LIBRARIES="jupyter pandas keras sklearn seaborn $TF"

while getopts "bghm:rv:p:" x; do
    case "$x" in
        h)
            echo "usage: $0 [options]

Installs latest Python using Miniconda3 and setup venv for TensorFlow.

    -b             run install in batch mode (without manual intervention),
                   it is expected the Miniconda3 license terms are agreed upon
    -g             install tensorflow-gpu, defaults to tensorflow
    -h             print this help message and exit
    -m MC_PREFIX   miniconda install prefix, defaults to $MC_PREFIX
    -r             reuse existing miniconda install prefix
    -v VENV_PREFIX venv install prefix, defaults to $VENV_PREFIX
    -p 'p1 p2'     install python library, defaults to $PYTHON_LIBRARIES
"
            exit 2
            ;;
        b)
            BATCH=1
            ;;
        g)
            TF_GPU="-gpu"
			TF="tensorflow$TF_GPU"
            VENV_PREFIX="$HOME/venv/$TF"
			PYTHON_LIBRARIES="jupyter pandas keras sklearn seaborn $TF"
            ;;
        m)
            MC_PREFIX="$OPTARG"
            ;;
        r)
            MC_REUSE=1
            ;;
        v)
            VENV_PREFIX="$OPTARG"
            ;;
        p)
            PYTHON_LIBRARIES="$OPTARG"
            ;;
        ?)
            echo "Error: did not recognize option, please try -h"
            exit 1
            ;;
    esac
done

# run script in interactive mode
if [[ $BATCH == 0 ]]
then
    echo -n "
Welcome to Python vevn setup (by Martins Bruvelis)

Please, press ENTER to continue
>>> "
    read dummy
    echo -n "
Miniconda3 will be installed into this location:
$MC_PREFIX

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[$MC_PREFIX] >>> "
    read user_miniconda_prefix
    if [[ $user_miniconda_prefix != "" ]]; then
        case "$user_miniconda_prefix" in
            *\ * )
                echo "ERROR: Cannot install into directories with spaces" >&2
                exit 1
                ;;
            *)
                eval MC_PREFIX="$user_miniconda_prefix"
                ;;
        esac
    fi
    echo -n "
Python venv will be installed into this location:
$VENV_PREFIX

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[$VENV_PREFIX] >>> "
    read user_venv_prefix
    if [[ $user_venv_prefix != "" ]]; then
        case "$user_venv_prefix" in
            *\ * )
                echo "ERROR: Cannot install into directories with spaces" >&2
                exit 1
                ;;
            *)
                eval VENV_PREFIX="$user_venv_prefix"
                ;;
        esac
    fi
    echo -n "
Python venv will install following libraries:
$PYTHON_LIBRARIES

  - Press ENTER to confirm the Python libraries
  - Press CTRL-C to abort the installation
  - Or specify a different Python libraries

[$PYTHON_LIBRARIES] >>> "
    read venv_libraries
    if [[ $venv_libraries != "" ]]; then
        PYTHON_LIBRARIES="$venv_libraries"
    fi
    echo -n "
We will now downlaod and install Python, review settings:
miniconda url:    $MC_URL
miniconda prefix: $MC_PREFIX
venv prefix:      $VENV_PREFIX
python libraries: $PYTHON_LIBRARIES

  - Press ENTER to confirm and continue
  - Press CTRL-C to abort the installation
>>> "
    read dummy
fi # end interactive mode

# check if miniconda directory already exists
if [[ ($MC_REUSE == 0) && (-e $MC_PREFIX) ]]; then
    echo "ERROR: File or directory already exists: $MC_PREFIX" >&2
    exit 1
fi

if [[ $MC_REUSE == 0 ]]
then
    # download miniconda
    wget "$MC_URL" -O "$THIS_DIR/$MC_LATEST"
    # install miniconda
    bash "$THIS_DIR/$MC_LATEST" -b -p "$MC_PREFIX"
    # remove downloaded miniconda installation
    rm "$THIS_DIR/$MC_LATEST"
    # update all miniconda libraries
    source "$MC_PREFIX/bin/activate" && conda update --all -y && source deactivate
fi
# create the venv
/bin/bash -c "source $MC_PREFIX/bin/activate && python -m venv --without-pip $VENV_PREFIX && echo -n conda $VENV_PREFIX && source deactivate"
# install pip inside venv
/bin/bash -c "source $VENV_PREFIX/bin/activate && curl https://bootstrap.pypa.io/get-pip.py | python && deactivate"
# install python libraries
/bin/bash -c "source $VENV_PREFIX/bin/activate && pip install --upgrade $PYTHON_LIBRARIES && deactivate"
echo -n "
The venv environment has been created, to activate it source 
an activate script in its bin directory, e.g. by executing:

source $VENV_PREFIX/bin/activate

"