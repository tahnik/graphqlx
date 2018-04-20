import * as HTTP from './http';

let ENABLED = false;

let batchedQueries = {};
let batchedResponse = {};

const exists = (id) => {
  return typeof batchedResponse[id] != 'undefined';
}

const enableBatch = (bool) => {
  if (bool === true) {
    console.info("Batching enabled");
    ENABLED = true;
  } else {
    console.info("Batching disabled");
    ENABLED = false;
  }
}

const add = (endpoint, query, headers, id) => {
  if (!ENABLED) {
    console.error("Batching not enabled");
    return { success: false };
  }
  console.info("Adding query to batch");
  batchedQueries[id] = {
    endpoint,
    query,
    headers
  };
  return { success: true };
}

const get = (id) => {
  if (typeof batchedResponse[id] == 'undefined') {
    return { success: false };
  }
  return { success: true, data: batchedResponse[id] };
}

const sendBatchRequests = () => {
  if (Object.keys(batchedQueries).length !== 0) {
    let queries = "{\n";
    let endpoint = "";
    let headers;
    Object.keys(batchedQueries).map((key) => {
      const query = batchedQueries[key];
      endpoint = query.endpoint;
      headers = query.headers;
      let tempQ = key + ": " + query.query.substring(1, query.query.length - 1);
      tempQ += "\n";
      queries += tempQ;
    })
    batchedQueries = {};
    queries += "}";
    console.log(queries);
    console.info("Sending Batch Requests");
    HTTP.POST(endpoint, queries, headers)
    .then((res) => {
      if (res.data) {
        batchedResponse = res.data;
      }
    })
    .catch(() => {
      batchedResponse = {};
    })
  }
}

setInterval(() => {
  sendBatchRequests();
}, 10);

setInterval(() => {
  batchedResponse = {};
}, 10000)

export { enableBatch, add, get, ENABLED, exists };