# Pronto runner for ESLint

[![Code Climate](https://codeclimate.com/github/prontolabs/pronto-eslint.png)](https://codeclimate.com/github/prontolabs/pronto-eslint)
[![Build Status](https://travis-ci.org/prontolabs/pronto-eslint.png)](https://travis-ci.org/prontolabs/pronto-eslint)
[![Gem Version](https://badge.fury.io/rb/pronto-eslint.png)](http://badge.fury.io/rb/pronto-eslint)
[![Dependency Status](https://gemnasium.com/prontolabs/pronto-eslint.png)](https://gemnasium.com/prontolabs/pronto-eslint)

Pronto runner for [ESlint](http://eslint.org), pluggable linting utility for JavaScript and JSX. [What is Pronto?](https://github.com/prontolabs/pronto)

## Prerequisites

You'll need to install one of the runtimes supported by [ExecJS](https://github.com/sstephenson/execjs#execjs).

## Configuration

Configuring ESLint via .eslintrc will work just fine with pronto-eslint, though it will not support
searching higher up the path hierarch. To use an absolute path to your config, use `ESLINT_CONFIG`.

## Testing

The tests use a fixture git repository that has been created under the spec/fixtures/test.git folder. This folder is almost like a child repo of the parent repo where this README is contained. If you need to add or modify a test, you might need to modify the child repository. To do this, perform the following steps:

1. Navigate to the `spec/fixtures/test.git` directory.
2. mv the `git` folder to `.git` to make the child git repo active again: `mv git .git`.
3. Add/modify/remove a file.
4. Add and commit all of the changes: `git commit -a`.
5. Move the `.git` folder back to the `git` folder so that the changes show up in the parent repo: `mv .git git`.
6. Navigate back to the root directory: `cd ../../../`
7. Add and commit all of the changes in the parent repo: `git commit -a`.

If you run `git status` after moving the `.git` folder back to the `git` folder, you can see a list of the files that git has changed that will be committed in the parent repo.
