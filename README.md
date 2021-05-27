SolidusSimpleDash
=================
[![CircleCI](https://circleci.com/gh/magma-labs/solidus_simple_dash.svg?style=shield)](https://circleci.com/gh/magma-labs/solidus_simple_dash)
[![codecov](https://codecov.io/gh/magma-labs/solidus_simple_dash/branch/master/graph/badge.svg)](https://codecov.io/gh/magma-labs/solidus_simple_dash)

Add simple dashboard to review your sales based on variants, products and orders, it contains:
- Best selling products
- Top grossing products
- Best selling taxons
- Abandoned carts
- Abandoned cart items
- Checkout steps
- New users

Installation
------------

Add this line to your solidus application's Gemfile:

```ruby
gem 'solidus_simple_dash', github: 'magma-labs/solidus_simple_dash'
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
![solidus_simple_dash](https://user-images.githubusercontent.com/957520/43218208-597c6014-9009-11e8-8155-c2f583cf4627.png)

Testing
-------

Then just run the following to automatically build a dummy app if necessary and
run the tests:

```shell
bundle exec rake
```
