const AWS = require("aws-sdk");

const log_and_stream_name = process.env.AWS_LOG_GROUP_AND_STREAM;

// AWS SDK will now automatically determine the region.
const cloudwatchlogs = new AWS.CloudWatchLogs();

const logGroupName = log_and_stream_name;
const logStreamName = log_and_stream_name;

function logToCloudWatch(logMessage) {
  const params = {
    logGroupName,
    logStreamName,
    logEvents: [
      {
        message: logMessage,
        timestamp: new Date().getTime(),
      },
    ],
  };

  cloudwatchlogs.putLogEvents(params, (err, data) => {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data);
    }
  });
}

module.exports = {
  logToCloudWatch,
};

