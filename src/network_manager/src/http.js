import axios from 'axios';
import * as Cache from './cache';

const POST = (endpoint, query, headers) => {
  return new Promise(function(resolve, reject) {
    axios.post(
      endpoint,
      { query: query },
      {
        headers
      }
    )
    .then((response) => {
      const { data } = response;
      const jsonS = JSON.stringify(data);
      Cache.set(query, jsonS);
      resolve(data);
    })
    .catch((err) => {
      reject(err);
    })
  });
}

export { POST };