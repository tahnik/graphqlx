const GraphQL = require("../dist/graphqlx");

let query1 = `{
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

let query2 = `{
  getLocation(ip: "81.108.142.173") {
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

let query3 = `{
  getLocation(ip: "151.101.1.195") {
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

test('Graphloc Batch', done => {
  GraphQL.enableBatch(true);

  GraphQL.fetch("https://api.graphloc.com/graphql", query1)
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.graphloc.com/graphql", query2)
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.graphloc.com/graphql", query3)
  .then((res) => {
    done();
  })
  .catch((err) => {
    console.log(err);
  })
});
