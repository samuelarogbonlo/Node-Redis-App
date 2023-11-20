const Sequelize = require("sequelize");

const db_user = process.env.POSTGRES_USER;
const db_password = process.env.POSTGRES_PASSWORD;
const db_url = process.env.POSTGRES_URL;

const sequelize = new Sequelize("", db_user, db_password, {
  host: db_url,
  dialect: "postgres",
  port: 5432,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
});

module.exports = sequelize;
