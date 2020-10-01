#! /bin/bash

set -e

ecoevolity_commit="c128046c"

# Get path to directory of this script
project_dir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load modules
echo "Loading modules..."
source ./modules-to-load.sh >/dev/null 2>&1 || echo "    No modules loaded"

echo "Creating Python 2 virtual environment for running PyMsBayes..."
# Python 2 is needed to setup the python environment for running PyMsBayes, but
# the module is not needed once it is setup
module load python/2.7.15 >/dev/null 2>&1 || \
    echo "Using system's Python 2 to setup virtual environment"

pip2 install virtualenv
virtualenv pyenv-abc
source pyenv-abc/bin/activate
pip2 install --upgrade pip
pip2 install wheel
pip2 install -r python-requirements-abc.txt
deactivate

module unload python/2.7.15 >/dev/null 2>&1 || \

echo "Creating Python 3 virtual environment for everything else..."
# Python 3 is needed to setup the python environment, but the module is not
# needed once it is setup
module load python/3.6.4 >/dev/null 2>&1 || \
    echo "Using system's Python 3 to setup virtual environment"

python3 -m venv pyenv
source pyenv/bin/activate
pip3 install --upgrade pip
pip3 install wheel
pip3 install -r python-requirements.txt

echo "Cloning, building, and installing ecoevolity..."
git clone https://github.com/phyletica/ecoevolity.git
(
    cd ecoevolity
    git checkout -b testing "$ecoevolity_commit"
    ./build.sh --prefix "$project_dir"
    echo "    Commit $ecoevolity_commit of ecoevolity successfully built and installed"
    cd ..
)
