const User = require("../models/data.model");
const redisClient = require("../services/redis");
const client = require("prom-client");

const databaseQueryCounter = new client.Counter({
  name: "database_queries_total",
  help: "Total number of database queries",
});

const cacheHitCounter = new client.Counter({
  name: "cache_hits_total",
  help: "Total number of cache hits",
});

exports.addData = async (req, res) => {
  try {
    const { name, email, age } = req.body;
    const database_data = await User.findOne({ where: { email } });
    if (database_data) {
      return res
        .status(201)
        .json({ message: "User with email created already" });
    }
    const newData = await User.create({
      name,
      email,
      age,
    });

    databaseQueryCounter.inc();

    const redisKey = `userData:${email}`;
    await redisClient.set(redisKey, JSON.stringify(newData), "EX", 3600);

    console.log("Created a new user data");

    return res.status(201).json(newData);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getData = async (req, res) => {
  try {
    const { email } = req.query;

    const redisKey = `userData:${email}`;

    const cached_data = await redisClient.get(redisKey);
    console.log(cached_data, "from cache");
    console.log("Fetch a new user data from cache");
    cacheHitCounter.inc();

    if (cached_data) {
      res.status(200).json(JSON.parse(cached_data));
    } else {
      const database_data = await User.findOne({ where: { email } });
      console.log("from db");
      console.log("Fetch a new user data from db");
      databaseQueryCounter.inc();
      if (database_data) {
        await redisClient.set(
          redisKey,
          JSON.stringify(database_data),
          "EX",
          3600
        );
        res.status(200).json(database_data);
      } else {
        res.status(404).json({ message: "Data not found" });
      }
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

