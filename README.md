SolidusSimpleDash
=================
[![Build Status](https://travis-ci.org/magma-labs/solidus_simple_dash.svg?branch=master)](https://travis-ci.org/magma-labs/solidus_simple_dash)

Add simple dashboard to review your sales based on variants, products and orders, it contains:
- Best selling products
- Top grossing products
- Best selling taxons
- Abandoned carts
- Abandoned cart items
- Checkout steps

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
![solidus_simple_dash](https://user-images.githubusercontent.com/957520/42961497-8d9762c2-8b54-11e8-8a7a-c67132c799fc.png)

Testing
-------

Then just run the following to automatically build a dummy app if necessary and
run the tests:

```shell
bundle exec rake
```
