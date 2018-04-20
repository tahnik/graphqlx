import fetch from 'node-fetch';
import * as Cache from './cache';

const POST = (endpoint, query, headers) => {
  return new Promise(function(resolve, reject) {
    fetch(
      endpoint,
      {
        method: 'POST',
        body: JSON.stringify({ query: query }),
        headers: { 'Content-Type': 'application/json', ...headers }
      }
    )
    .then((response) => {
      const res = response.json();
      Cache.set(query, res);
      resolve(res);
    })
    .catch((err) => {
      reject(err);
    })
  });
}

export { POST };