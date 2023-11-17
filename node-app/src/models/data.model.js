const sq = require("../services/db");
const { DataTypes } = require("sequelize");

const User = sq.define("user", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true, // Automatically increment the id for each new entry
    allowNull: false,
  },

  name: {
    type: DataTypes.STRING,
    allowNull: false,
    primaryKey: true,
  },

  email: {
    type: DataTypes.STRING,
  },

  age: {
    type: DataTypes.INTEGER,
  },
});

User.sync().then(() => {
  console.log("User Model synced");
});

module.exports = User;
