from invoke import run, task

@task
def test():
  run("python ios7crypt.py -e monkey")
  run("python ios7crypt.py -d 011e090a500e1f")

@task
def pep8():
  run("pep8 .")

@task
def pylint():
  run("pylint *.py")

@task
def pyflakes():
  run("pyflakes .")

@task(pre=[pep8, pylint, pyflakes])
def lint():
  pass
