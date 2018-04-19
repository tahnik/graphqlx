let cache = {};

let ENABLED = false;

const enableCache = (bool) => {
  if (bool === true) {
    console.info("Caching enabled");
    ENABLED = true;
  } else {
    console.info("Caching disabled");
    ENABLED = false;
  }
}

const exists = query => {
  return typeof cache[query] != 'undefined';
}

const get = query => {
  if (!ENABLED) {
    console.error("Cache not enabled");
    return { success: false };
  }
  if (!exists(query)) {
    console.error("Query does not exist in the cache");
    return { success: false };
  }
  console.log("Retrieving data from cache");
  return { success: true, data: cache[query] };
}

const set = (query, response) => {
  if (!ENABLED) {
    console.error("Cache not enabled");
    return { success: false };
  }
  if (exists(query)) {
    console.info("Query exists in the cache. Will be rewriting");
  }
  cache[query] = {
    response,
    added_on: Date.now()
  };
  console.log("Query saved in the cache");
  return true;
}

const clear = () => {
  let i = 0;
  Object.keys(cache).map(key => {
    const timeElapsed = (Date.now() - cache[key].added_on)/1000;
    if (timeElapsed > 5) {
      delete cache[key];
      i++;
    }
  });
  if (ENABLED && i !== 0) {
    console.info("Cleared " + i + " query from cache");
  }
}

setInterval(() => {
  clear();
}, 5000);

export { exists, get, set, enableCache, ENABLED };