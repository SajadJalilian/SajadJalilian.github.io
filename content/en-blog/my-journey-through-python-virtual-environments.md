---
title: "My Journey Through Python Virtual Environments"
date: 2020-10-20T19:05:13+03:30
tags: ["python"]
type: "en"
---

Since I started programming in Python, I was perfectly fine using its standard library tool, `venv`, for all my work. You can create a virtual environment using `venv` like this:

```bash
python -m venv <venv_name>
```

In the Python ecosystem, there are four well-known tools for creating virtual environments:

- [Standard library venv](https://docs.python.org/3/library/venv.html)
- [Virtualenv package](https://virtualenv.pypa.io/)
- [Pipenv](https://pipenv.pypa.io/)
- [Conda environments](https://docs.conda.io/projects/Conda/en/latest/user-guide/concepts/environments.html)

I won’t dive deep into the differences between these tools, as you can find excellent comparison articles elsewhere. For instance, [this StackOverflow thread](https://stackoverflow.com/questions/1534210/use-different-python-version-with-virtualenv) is quite useful.

A while ago, I started working on a project that required three different Python versions: 2.7, 3.3, and 3.8.

My main concern was finding a straightforward way to use, install, switch between, and create virtual environments for different Python versions.

Unfortunately, my favorite tool, `venv`, does not support specifying the Python version for a virtual environment. To use different Python versions, you first have to install the desired version and then use it to create the virtual environment. The bad news is that `venv` was introduced in Python 3.6, so it’s only available for 3.6 and later versions. :( As a result, I had to switch to the `Virtualenv` package.

To create a virtual environment with a specific Python version using `virtualenv`, you can do:

```bash
virtualenv venv --python=python2.7
```

Alternatively, you could use the shiny `Pipenv` tool to create virtual environments and enjoy its cool features. However, I found `virtualenv` to be good enough for my needs.

### The Pain of Managing Python Versions

Over time, managing multiple Python versions became a major headache. I had to download old versions, build them, install them, and keep them organized.

I had previously used `Conda environments`, which allow you to install any Python version in an isolated environment. If a specified Python version isn’t already installed, Conda automatically downloads and installs it for you — no manual work needed.

To create a virtual environment with a specific Python version using Conda, you can do:

```bash
conda create -n myenv python=3.6
```

I was happy with Conda until I hit another roadblock. It turned out that Conda doesn’t support Python 3.3.7, which I needed for my project. In fact, Conda’s Python version support is much more limited compared to `pyenv`, even though Conda uses `pyenv` under the hood.  
So, once again, I had to try a new tool: my new favorite, `pyenv`.

### Enter `pyenv` and `pyenv-virtualenv`

RealPython has an excellent article about using `pyenv` ([check it out here](https://realpython.com/intro-to-pyenv)). With `pyenv`, you can easily install and manage different Python versions. Its plugin, `pyenv-virtualenv`, allows you to work with virtual environments effortlessly, similar to Conda environments but with more flexibility.

### My Recommendations

Having used all of these tools, I can say that each has its pros and cons. Here’s my advice:

- If you don’t care about Python versions earlier than 3.6 and don’t need to install more than three different Python versions for the rest of your life, just use the `Standard library venv`.
- If `Conda environments` support all the Python versions you need, go for it.
- If you’re like me and need to use ancient Python versions and expect to add even more in the future, use `pyenv` and `pyenv-virtualenv` to save yourself a lot of headaches.
- Finally, you can use `Pipenv` for [entirely different reasons](https://realpython.com/pipenv-guide). The good news is that you can also use it alongside `pyenv` ([read more here](https://hackernoon.com/reaching-python-development-nirvana-bb5692adf30c)).

### Final Thoughts

This is my first English article, so I apologize for any mistakes. Google Docs helped me catch many of my errors in spelling and grammar. I’m learning every day and hope to improve over time.
