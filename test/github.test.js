const { fetch } = require("../dist/graphqlx");

let header = { Authorization: "bearer 619c80748dde531f7fa7e14b51f13346c38dfd55" };
let query = `query {
  repository(owner:"octocat", name:"Hello-World") {
    issues(last:20, states:CLOSED) {
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

test('Graphloc', () => {
  return expect(fetch("https://api.github.com/graphql", query, header)).resolves.toBeObject();
});