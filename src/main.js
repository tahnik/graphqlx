import { parse } from "../lib/js/parse";
import { validate } from "../lib/js/validate";
import { POST } from "./http/src/http";

const fetch = (endpoint, query, header) => {
  validate(query);
  POST(endpoint, query, header);
};

