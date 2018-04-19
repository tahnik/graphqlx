import * as Cache from './cache';
import * as Batch from './batch';
import * as HTTP from './http';

const enableCache = (bool) => {
  Cache.enableCache(bool);
}

const enableBatch = (bool) => {
  Batch.enableBatch(bool);
}

const get = (endpoint, query, headers) => {
  if (Cache.exists(query)) {
    return new Promise(function(resolve, reject) {
      resolve(Cache.get(query));
    });
  }
  if (Batch.ENABLED) {
    if (query.charAt(0) == "{") {
      const id = "U" + Math.floor(Date.now() + ((Math.random() * 100) + 1));
      Batch.add(endpoint, query, headers, id);
      return new Promise(function(resolve, reject) {
        let timePassed = 0;
        setInterval(() => {
          if (timePassed > 10) {
            reject("Could not get a response");
          } else {
            if (Batch.exists(id)) {
              resolve(Batch.get(id).data);
            }
          }
          timePassed++;
        }, 200);
      });
    } else {
      return makeRequest(endpoint, query, headers);
    }
  } else {
    return HTTP.POST(endpoint, query, headers);
  }
};


export { get, enableCache, enableBatch };