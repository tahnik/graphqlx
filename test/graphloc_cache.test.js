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

jest.setTimeout(10000);

GraphQL.enableCache(true);

test('Graphloc Cache: All the requests should be resolved', done => {
  let i = 0;
  setInterval(() => {
    if (i > 4) {
      done();
    }
    GraphQL.fetch("https://api.graphloc.com/graphql", query);
    i++;
  }, 1000);
});