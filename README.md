This repo demonstrates a crash when trying to decode a mutually recursive data structure with `lazy`.

To reproduce:

```bash
elm package install

# if you don't have elm-test yet:
npm install -g elm-test

elm-test
```

When running elm-test like this it should crash with this message:
> Unhandled exception while running the tests: [TypeError: Cannot read property 'tag' of undefined]