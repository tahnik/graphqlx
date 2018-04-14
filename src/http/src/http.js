import axios from "axios";

let POST = (endpoint, query, headers) => {
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
    console.log(jsonS);
  })
  .catch((err) => {
    console.log(err);
  })
};

export { POST };