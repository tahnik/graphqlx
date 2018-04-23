const GraphQL = require("../dist/graphqlx.node");

let header = { Authorization: "bearer 619c80748dde531f7fa7e14b51f13346c38dfd55" };
let query = `query {
  repository(owner:"tahnik", name:"devRantron") {
    issues(last:5, states:CLOSED) {
      edges {
        node {
          title
          url
          labels(first:5) {
            edges {
              node {
                name
              }
            }
          }
        }
      }
    }
  }
}`;

jest.setTimeout(10000);

GraphQL.enableCache(true);

test('GitHub Cache: All the requests should be resolved', done => {
  let i = 0;
  setInterval(() => {
    if (i > 4) {
      done();
    }
    GraphQL.fetch("https://api.github.com/graphql", query, header);
    i++;
  }, 1000);
});