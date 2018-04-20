const GraphQL = require("../dist/graphqlx");

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

GraphQL.enableCache(true);

setInterval(() => {
  GraphQL.fetch("https://api.github.com/graphql", query, header)
  .then(res => {
    console.log(res);
  })
}, 1000);