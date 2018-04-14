# GraphQLx - A JavaScript Client Library for GraphQL
***
This JavaScript library uses a unique combination OCaml and JavaScript in order to achieve better performance and maintainance. 

The tools used to build is library are:
  * ocamllex
  * menhir
  * ocamlbuild
  * bucklescript
  * webpack

## How to use
The package is available as npm package. To install the package, run the following command:
```
npm install --save graphqlx
```

then import in your JavaScript file;
```
// es6
import { fetch, parse, validate } from 'graphqlx';

// commonJS
const { fetch, parse, validate } = require('graphqlx');
```

The library exposes 3 different functions:

  * `fetch(endpoint: string, query: string, headers: object)`
  * `parse(query: string, pretty_print: boolean)`
  * `validate(query: string)` 

Here are some examples:
### fetch
```
let query = `{
  me {
    name
  }
}`;

let endpoint = "https://api.example.com";

fetch(endpoint, query);
```

If need to add a header to the request:

```
let query = `{
  me {
    name
  }
}`;

let endpoint = "https://api.example.com";

let config = { Authorization: "bearer SOME_TOKEN" };

fetch(endpoint, query, config);
```

### parse
This function parses the query.
```
let query = `{
  me {
    name
  }
}`;

parse(query);
```
You can add a optional boolean argument in `parse()` to print out the AST tree.

```
let query = `{
  me {
    name
  }
}`;

parse(query, true);
```

### validate
This function parses and validates the query.
```
let query = `{
  me {
    name
  }
}`;

validate(query);
```

## Contribute

This project can only be developed in linux. Here are the instructions for debian based distros:

### Prerequisite

```
sudo apt install build-essentials
```

### Dependencies

* ocaml: `sudo apt install ocaml`
* opam: `sudo apt install opam`
* menhir: `opam install menhir`
* nodejs: Follow the instruction from NodeJS website.

Once you have everything installed, make a pull request and I will have a look :)

## LICENSE
MIT