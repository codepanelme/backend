'use strict';

const uuid = require('uuid');
const AWS = require('aws-sdk');

AWS.config.setPromisesDependency(require('bluebird'));

const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports.webhook = (event, context, callback) => {
  const content = JSON.parse(event.body);

  createRecord(formatRecord(content))
    .then(res => {
      callback(null, {
        statusCode: 200,
        body: JSON.stringify({
          message: `New record sucessfully created: ${res}`
        })
      });
    })
    .catch(err => {
      console.log(err);
      callback(null, {
        statusCode: 500,
        body: JSON.stringify({
          message: `Error on creating a new record: ${err}`
        })
      })
    });
};

const createRecord = (content) => {
  console.log("Creating new record...");
  const record = {
    TableName: 'github_webhook_data',
    Item: content,
  };
  return dynamoDb.put(record).promise().then(res => content);
}

const formatRecord = (content) => {
  const timestamp = new Date().getTime();
  return {
    id: uuid.v1(),
    content: content,
    createdAt: timestamp,
    updatedAt: timestamp,
  };
};