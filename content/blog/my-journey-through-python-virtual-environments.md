---
title: "My Journey Through Python Virtual Environments"
date: 2020-10-20T19:05:13+03:30
---

Since I started programming in python, I was fine using its standard library tool ‘venv’ for all of my work. You can create venv like this:

``` bash
Python -m venv <venv name>
```

In the python ecosystem, there are 4 famous tools for creating virtual environments:

- [Standard library venv](https://docs.python.org/3/library/venv.html)
- [Virtualenv package](https://virtualenv.pypa.io/)
- [Pipenv](https://pipenv.pypa.io/)
- [Conda envirments](https://docs.conda.io/projects/Conda/en/latest/user-guide/concepts/environments.html)

I don’t want to go in-depth of the differences between these tools; you can find useful compression articles for any of these tools against another one. For example [this StackOverFlow thread](https://stackoverflow.com/questions/1534210/use-different-python-version-with-virtualenv)

A while ago, I started working on the project with 3 python versions, 2.7 / 3.3 / 3.8.

My main concern was using different python versions, install, switch and create venv for them as straightforward as it’s possible.

Unfortunately my favorite tool ‘standard library venv’ does not support specifying python version for venv. If you want to use different python versions you have to install that version and use it to create your venv for that particular python version. The bad news is, this tool was added after python 3.6, and you can use it for 3.6 and above versions :( So I had to use the ‘Virtualenv package’ instead.

You can create a virtual environment with different python version like this:

``` bash
virtualenv venv --python=python2.7
```

Alternatively, you can use the shiny ‘Pipenv’ tool to create venv and enjoy its cool functionalities, but I think ‘virtualenv’ is good enough for me.

After a while dealing with different python versions started to be a bad pain, I had to download old versions and build and install and manage them.

I used the ‘Conda environment’ before; you can install any python version you want in an isolated environment. If you specify a Python version that does not exist, Conda itself installs it, and you don’t need to do anything.

You can create a virtual environment with different python version using Conda like this:

``` bash
conda create -n myenv python=3.6
```

I was happy using Conda until bad news happened again, it’s turned out Conda doesn’t support python 3.3.7 which I needed for my project. In fact, Conda python version support is much limited compared to ‘pyenv’, even though Conda uses ‘pyenv’ under the hood.  
So again I had to try a new tool, my new favorite ‘pyenv’. RealPython has an excellent article about using it ([this one](https://realpython.com/intro-to-pyenv)).  
With pyenv you can easily install and manage different python versions, and with its plugin ‘pyenv-virtualenv’ you can work with different venvs easily, something like Conda environments but on steroids!

I used all of them, and each one has its pros and cons. My suggestion is if you don’t care about python lower than 3.6 and don’t need to install more than 3 different python versions for the rest of your life, just use ‘Standard library venv’. If ‘Conda environments’ support all of the python versions that you need, go for it. If you are like me and have to use ancient python versions and you will add more of them for your projects, use ‘pyenv’ and ‘pyenv-virtualenv’ and save yourself many headaches. In the end, you can use ‘pipenv’ for totally [different reasons](https://realpython.com/pipenv-guide). Good news is you can use it with ‘pyenv’ [reade more](https://hackernoon.com/reaching-python-development-nirvana-bb5692adf30c).

PS: This is my first English article, sorry for my bad English. Google doc helped me to find out many of my mistakes in writing words etc. I’m learning every day.
