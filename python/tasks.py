from invoke import run, task

@task
def test():
  run("python ios7crypt.py -e monkey")
  run("python ios7crypt.py -d 011e090a500e1f")

@task
def pylint():
  run("pylint *.py")

@task
def pyflakes():
  run("pyflakes .")

@task("pylint", "pyflakes")
def lint():
  pass
