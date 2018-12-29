# n-test

Prototype and develop a set of automated tests for `n`.

## Setup

Run `npm install` to install `bats`.

Add `.env` file beside `docker-compose.yml` with variable for `N_SCRIPT_FOR_TESTS`, to mount `n` script into container for testing.
(This is a temporary extra step while the tests are separate from the `n` repo, as `n` is not in a known location.)

e.g.

    N_SCRIPT_FOR_TESTS=/Users/john/Documents/Sandpits/n/bin/n

## Running Tests Locally

Run all the tests:

    npm run test

Run single test, three different ways of running locally installed `bats`:

    npx bats test/tests/install-contents.bats
    npm run bats test/tests/install-contents.bats
    node_modules/.bin/bats test/tests/install-contents.bats

## Docker

Using `docker-compose` in addition to `docker` for convenient mounting of `n` script and the tests into the container. Changes to the tests or to `n` itself are reflected immediately without needing to rebuild the containers.

`bats` is being mounted directly out of `node_modules` into the container as a manual install based on its own install script. This is a bit of a hack, but avoids needing to install `git` or `npm` for a full remote install of `bats`, and means everything on the same version of `bats`.

The containers each have:

* either curl or wget (or both) installed

Using `docker-compose` adds:

* specified `n` script mounted to `/usr/local/bin/n`
* `test/tests` mounted to `/mnt/tests`
* `node_modules/bats` provides `/usr/local/bin/bats` et al

So for example:

    docker-compose run ubuntu-curl
      # in container
      n --version
      bats /mnt/tests

## Proxy

To speed up the tests, you can optionally run a caching proxy. This requires modifying the curl settings to allow an insecure connection (i.e. through the mitm proxy).

NB: initially only supported for running tests natively. Docker proxy support still coming.

    cd tests
    bin/proxy-build
    bin/proxy-run
    # follow the instructions for configuring environment variables for using proxy
