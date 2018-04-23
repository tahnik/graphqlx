const GraphQL = require("../dist/graphqlx");

let header = { Authorization: "bearer 619c80748dde531f7fa7e14b51f13346c38dfd55" };
let query1 = `{
  repository(owner:"tahnik", name: "devRantron") {
    issues(last:5, states:CLOSED) {
      edges {
        node {
          title
        }
      }
    }
  }
}`;

let query2 = `{
  viewer {
    name
  }
}`;

let query3 = `{
  licenses {
    key
  }
}`;

GraphQL.enableBatch(true);

test('Graphloc Batch', done => {
  GraphQL.enableBatch(true);

  let q1, q2, q3 = false;

  GraphQL.fetch("https://api.github.com/graphql", query1, header)
  .then(() => {
    q1 = true;
  })
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.github.com/graphql", query2, header)
  .then(() => {
    q2 = true;
  })
  .catch((err) => {
    console.log(err);
  })

  GraphQL.fetch("https://api.github.com/graphql", query3, header)
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