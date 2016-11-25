This repo demonstrated a crash when trying to decode a mutually recursive data structure with `lazy` (see tag 'broken'). It was fixed by using a second `lazy` as suggested by a-l-f on the elm slack.

To reproduce:

```bash
elm package install

# if you don't have elm-test yet:
npm install -g elm-test

elm-test
```

When running elm-test like this it used to crash with this message:
> Unhandled exception while running the tests: [TypeError: Cannot read property 'tag' of undefined]
