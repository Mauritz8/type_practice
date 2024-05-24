# Type Practice Website
A simple web application to help users improve their typing skills.


## Technologies
* **Frontend:** HTML, CSS, JavaScript, HTMX
* **Backend:** OCaml

## Build
To start the server, use the following commands:
```
# install dependencies
opam install . --deps-only --with-test --with-doc

# setup environment
eval $(opam env)

# launch server
dune exec ./bin/server.exe
```
