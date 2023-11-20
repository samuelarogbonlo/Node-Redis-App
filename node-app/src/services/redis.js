const redis = require("redis");

const redis_password = process.env.REDIS_PASSWORD;
const url = `redis://${process.env.REDIS_URL}`;

const client = redis.createClient({
    url,
    password: redis_password
});


console.log(client)

client.on("error", (err) => {
  console.log("Redis Client Error", err);
});

client.connect();

module.exports = client;
