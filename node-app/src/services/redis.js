const redis = require("redis");

const redis_user = process.env.REDIS_USER;
const redis_password = process.env.REDIS_PASSWORD;
const redis_url = process.env.REDIS_URL;

const client = redis.createClient({
  host: redis_url,
  port: 6379,
  password: redis_password,
  username: redis_user,
});

console.log(client)

client.on("error", (err) => {
  console.log("Redis Client Error", err);
});

client.connect();

module.exports = client;
