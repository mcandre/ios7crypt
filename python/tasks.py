from invoke import run, task


@task
def safety():
    run('safety check')


@task
def test():
    run('python ios7crypt.py -e monkey')
    run('python ios7crypt.py -d 011e090a500e1f')


@task
def pep8():
    run('pep8 .')


@task
def pylint():
    run('pylint *.py')


@task
def pyflakes():
    run('pyflakes .')


@task
def flake8():
    run('flake8 .')


@task
def bandit():
    run('find . -name \'*.py\' | xargs bandit')


@task(pre=[safety, pep8, pylint, pyflakes, flake8, bandit])
def lint():
    pass
