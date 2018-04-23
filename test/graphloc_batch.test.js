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

GraphQL.enableBatch(true);
test('Graphloc Batch: All the requests should be resolved', done => {
  let q1, q2, q3 = false;

  GraphQL.fetch("https://api.graphloc.com/graphql", query1)
  .then(() => {
    q1 = true;
  })
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.graphloc.com/graphql", query2)
  .then(() => {
    q2 = true;
  })
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.graphloc.com/graphql", query3)
  .then((res) => {
    q3 = true;
  })
  .catch((err) => {
    console.log(err);
  })

  setInterval(() => {
    if (q1 && q2 && q3) {
      done();
    }
  }, 10);
});
