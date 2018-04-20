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
      resolve(Cache.get(query).data);
    });
  }
  if (Batch.ENABLED) {
    if (query.charAt(0) == "{") {
      const id = "U" + Math.floor(Date.now() + ((Math.random() * 100) + 1));
      Batch.add(endpoint, query, headers, id);
      return new Promise(function(resolve, reject) {
        let timePassed = 0;
        let tim = setInterval(() => {
          if (timePassed > 400) {
            clearInterval(tim);
            reject("Could not get a response");
          } else {
            if (Batch.exists(id)) {
              clearInterval(tim);
              resolve(Batch.get(id).data);
            }
          }
          timePassed++;
        }, 5);
      });
    } else {
      return HTTP.POST(endpoint, query, headers);
    }
  } else {
    return HTTP.POST(endpoint, query, headers);
  }
};


export { get, enableCache, enableBatch };