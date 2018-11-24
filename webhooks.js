'use strict';

const AWS = require('aws-sdk');

AWS.config.setPromisesDependency(require('bluebird'));

const dynamoDb = new AWS.DynamoDB.DocumentClient({convertEmptyValues: true});

module.exports.github = (event, context, callback) => {
  createRecord(formatRecord(event))
    .then(newRecord => {
      callback(null, {
        statusCode: 201,
        body: JSON.stringify({
          message: "New record sucessfully created",
          record: JSON.stringify(newRecord)
        })
      });
    })
    .catch(error => {
      console.log(`Error: ${JSON.stringify(error)}`);
      callback(null, {
        statusCode: 500,
        body: JSON.stringify({
          message: "Error on creating a new record",
          error: JSON.stringify(error)
        })
      })
    });
};

const createRecord = (content) => {
  console.log(`Creating new record: ${JSON.stringify(content)}`);
  const record = {
    TableName: 'github_webhook_data',
    Item: content,
  };
  return dynamoDb.put(record).promise().then(res => content);
}

const formatRecord = (event) => {
  const timestamp = new Date().getTime();
  const id = event.headers['X-GitHub-Delivery'];
  const githubEvent = event.headers['X-GitHub-Event'];
  console.log(`Headers: ${JSON.stringify(event.headers)}`);
  console.log(`Body: ${event.body}`);

  return {
    id: id,
    event: githubEvent,
    payload: JSON.parse(event.body),
    createdAt: timestamp,
    updatedAt: timestamp,
  };
};