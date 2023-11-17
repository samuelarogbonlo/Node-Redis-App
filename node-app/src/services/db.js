const Sequelize = require("sequelize");

const db_user = process.env.POSTGRES_USER;
const db_password = process.env.POSTGRES_PASSWORD;
const db_url = process.env.POSTGRES_URL;

const sequelize = new Sequelize("postgres", db_user, db_password, {
  host: db_url,
  dialect: "postgres",
  port: 5432,
});

module.exports = sequelize;
