'use strict';

module.exports.github = async (event, context) => {
  console.log("EVENT: "+ console.log(JSON.stringify(event, null, 4)));
  console.log("CONTEXT: "+ console.log(JSON.stringify(context, null, 4)));

  return { statusCode: 200 };
};
