# machine-learning-python
Explore Machine Learning models and algorithms using Python and Jupyter Notebooks

## Setup Python 3.6 virtual environment (venv)
As Ubuntu 14.04 and Ubuntu 16.04 does not ship with Python 3.6 use bootstrapping script 
[tools/python-venv-setup.sh](tools/python-venv-setup.sh) to download and install latest 
Python 3.6 using Miniconda and setup venv with common ML Python libraries:
```bash
pip install --upgrade jupyter pandas keras sklearn h5py Pillow seaborn plotly bokeh tensorlfow{-gpu}
```
### Setup instructions for Python 3.6 virtual environment (venv)
#### Install git
```bash
sudo apt --yes install git
```
#### Create directory for python and ML libraries setup script
```bash
mkdir $HOME/src && cd $HOME/src
```
#### Clone repository with venv setup script by executing command:
```bash
git clone https://github.com/bruvelis/machine-learning-python.git
```
#### Run Python environemnt setup script by executing command and follow on-screen inscutrions to select Miniconda and Python virtual environment installation paths:
```bash
bash ./machine-learning-python/tools/python-venv-setup.sh
```
#### Alternatively, run setup script in batch mode without user interaction by using command line argument `-b` (default Miniconda install path is `$HOME/miniconda3`; default Python virtual environment path is `$HOME/venv/tensorflow`:
```bash
bash ./machine-learning-python/tools/python-venv-setup.sh -b
```
#### To update Python virtual environment libraries and reuse existing Miniconda and Python virtual environemnt you can use a command line argument `-r`:
```bash
bash ./machine-learning-python/tools/python-venv-setup.sh -b -r
```
#### If your system has Nvidia CUDA, CUDNN libraries, you can use a command line argument `-g` to install GPU-accelerated TensorFlow verision (default Python virtual environment path is then `$HOME/venv/tensorflow-gpu`):
```bash
bash ./machine-learning-python/tools/python-venv-setup.sh -b -g
```

### Setup Nvidia CUDA, CUDNN libraries on Ubuntu 16.04 (if you have Nvidia GPU-enabled platform):
#### Add public key for CUDA and CUDNN repositories
```bash
wget -q -O - http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub | sudo apt-key add
```
#### Add CUDA and CUDNN repository for Ubuntu 16.04 based Linux distributions
```bash
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /
deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
```
#### Update repository package list
```bash
sudo apt update
```
#### Install add-apt-repository for adding ppa (Personal Package Archive)
```bash
sudo apt --yes install software-properties-common
```
#### Install cuda-drivers (GPU drivers), CUDA Toolkit (GPU-accelerated libraries) and cuDNN (GPU-accelerated Deep Neural Network library)
```bash
sudo apt --yes install cuda-drivers cuda libcudnn5-dev libcudnn6-dev libcudnn7-dev
```

### To add support for NVIDIA Optimus technology under Linux (if you system supports Optimus technology):
#### Add bumblebee repository
```bash
sudo add-apt-repository -y ppa:bumblebee/testing && sudo apt update
```
#### Install bumblebee
```bash
sudo apt --yes install bumblebee
```
#### Set installed nvidia driver version in `/etc/bumblebee/bumblebee.conf`
```bash
sudo sed -i -E 's/(nvidia-+)([0-9]{3}|current)/\1'`dpkg -l | grep -E 'ii\s+nvidia-[0-9]{3}\s' | sed -E 's/^ii\s*nvidia-([0-9]{3})\s.*/\1/'`'/g' /etc/bumblebee/bumblebee.conf
```
#### Set Nvidia Graphics Card PCIE BusID in `/etc/bumblebee/xorg.conf.nvidia`
```bash
sudo sed -i "s/[# ]   BusID \"PCI.*/    BusID \"PCI:"`lspci -vnn | grep '\''[030[02]\]' | grep 10de | awk '{print $1}' | sed 's/\./:/'`\""/" /etc/bumblebee/xorg.conf.nvidia
```
#### Select intel as primary GPU driver
```bash
sudo prime-select intel
```
#### Restart and check bumblebeed deamon (reboot your system if restarting the service does not enable bumblebeed service):
```bash
sudo service bumblebeed restart
sudo service bumblebeed status
```
#### Install Miscellaneous Mesa GL utilities (`glxinfo`, `glxgears`)
```bash
sudo apt --yes install mesa-utils
```
#### Check NVIDIA Optimus technology (`optirun`)
```bash
optirun glxinfo -display :8 | grep OpenGL
```
