SolidusSimpleDash
=================
[![Build Status](https://travis-ci.org/jtapia/solidus_simple_dash.svg?branch=master)](https://travis-ci.org/jtapia/solidus_simple_dash)

Add simple dashboard to review your sales based on variants, products and orders

Installation
------------

Add this line to your solidus application's Gemfile:

```ruby
gem 'solidus_simple_dash', github: 'jtapia/solidus_simple_dash'
```

And then execute:

```shell
$ bundle
$ bundle exec rails g solidus_simple_dash:install
```

Usage
-----

Visit ```/overview``` on Admin section

Preview
-------
![solidus_simple_dash](https://user-images.githubusercontent.com/957520/42850562-d47afa9a-89ed-11e8-85d3-a7b6b189c07d.png)

Testing
-------

Then just run the following to automatically build a dummy app if necessary and
run the tests:

```shell
bundle exec rake
```
