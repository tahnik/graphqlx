import { parse } from "../lib/js/parse";
import { validate } from "../lib/js/validate";
import * as NetworkManager from "./network_manager/src/main";

const fetch = (endpoint, query, header) => {
  validate(query);
  return NetworkManager.get(endpoint, query, header);
};

const { enableCache, enableBatch } = NetworkManager;

export { fetch, parse, validate, enableCache, enableBatch };