const GraphQL = require("../dist/graphqlx");

let query = `{
  getLocation(ip: "189.59.228.170") {
    country {
      names {
        en
      }
      geoname_id
      iso_code
    }
    location {
      latitude
      longitude
    }
  }
}`;

GraphQL.enableCache(true);

GraphQL.fetch("https://api.graphloc.com/graphql", query);

setTimeout(() => {
  GraphQL.fetch("https://api.graphloc.com/graphql", query)
  .then(res => {
    console.log(res);
  })
}, 1000);