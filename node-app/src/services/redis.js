const redis = require("redis");
const client = redis.createClient({
  host: "localhost",
  port: 6379,
});

console.log(client)

client.on("error", (err) => {
  console.log("Redis Client Error", err);
});

client.connect();

module.exports = client;
