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
