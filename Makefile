.SILENT:
.PHONY: test

.libs/heroku-buildpack-testrunner:
	echo Downloading heroku-buildpack-test-runner
	git clone https://github.com/heroku/heroku-buildpack-testrunner .libs/heroku-buildpack-testrunner

.libs/shunit2:
	echo Downloading shunit2
	git clone https://github.com/kward/shunit2 .libs/shunit2

test: .libs/heroku-buildpack-testrunner .libs/shunit2
	SHUNIT_HOME=$(realpath $(@D))/.libs/shunit2/source/2.1 ./.libs/heroku-buildpack-testrunner/bin/run .
