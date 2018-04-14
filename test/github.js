import { fetch } from "../src/main";

let header = { Authorization: "bearer " };
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

fetch("https://api.github.com/graphql", query, header);