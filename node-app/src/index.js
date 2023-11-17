const express = require("express");
const routes = require("./routes/api.routes");
const sequelize = require("./services/db");
const client = require("prom-client");

const app = express();
app.use(express.json());

const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ timeout: 5000 });

const register = new client.Registry();
register.setDefaultLabels({
  app: "nodejs_application",
});
client.collectDefaultMetrics({ register });

app.use(express.urlencoded({ extended: true }));
app.use("/api", routes);

app.get("/metrics", async (req, res) => {
  try {
    res.set("Content-Type", register.contentType);
    res.end(await register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});

app.listen(4005, async () => {
  console.log("Server is Running on localhost://4005");

  try {
    await sequelize.authenticate();
    console.log("Database connected!");
  } catch (error) {
    console.error("Unable to connect to the database:", error);
  }
});
