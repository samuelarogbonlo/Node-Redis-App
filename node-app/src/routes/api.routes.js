const express = require("express");
const router = express.Router();

const statusController = require("../controllers/status.controller");
const dataController = require("../controllers/data.controller");

router.get("/status", statusController.getStatus);
router.post("/data", dataController.addData);
router.get("/get-data", dataController.getData);

module.exports = router;
