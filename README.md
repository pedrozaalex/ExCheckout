# Checkout

## Running

After [installing Elixir](https://elixir-lang.org/install.html), all you have to do is to `cd` into this folder and then type the following commands in a terminal:

```
mix deps.get
mix run
```

You will be greeted by a prompt that will help you do your checkout.

## Configuration

The products and discounts are very configurable, so by default we will try to read the configuration from the file `products_config.json`, but you can override that by exporting the `PRODUCTS_FILE_LOCATION` environment variable and pointing it to another file.

It's important that the new file's schema matches the old one, otherwise the app won't work.
