env-buildpack
=============

Heroku buildpack to make environment variables available in build time.

How to use it
-------------

Create a `.env-export` file at the repository root and list the
variables you want to export (one per line):

    $ cat .env-export
    MY_FIRST_VAR
    ANOTHER_RANDOM_VAR

Add this buildpack to your app. **Make sure this is the first buildpack
in the buildpack list**.

    $ heroku buildpacks:add --index 1 --app my-app https://github.com/loadsmart/env-buildpack

Done! Next time you deploy your code, the variables you specified in
the `.env-export` file will be available in the compile phase. 

**Note**: Although you can export (almost) any variable, avoid
exporting any variable that could result in a side-effect during build
phase. 

Development
-----------

We use [heroku-buildpack-testrunner](https://github.com/heroku/heroku-buildpack-testrunner)
to test the project. The test command will clone the repository
automatically and will run the tests:

    # This will clone the heroku-buildpack-testrunner
    $ make test

Contributing
------------

If you make changes to the buildpack that you think will benefit others,
please send a Pull Request. Just make sure that the tests passed before
opening it.

License
-------

This work is licensed under [MIT License](./LICENSE).

Copyright (c) 2017 Loadsmart, Inc.
