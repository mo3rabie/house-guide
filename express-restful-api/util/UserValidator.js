// util/userValidator.js

const Ajv = require('ajv');

// Define your schema for user validation
const userSchema = {
  type: 'object',
  properties: {
    username: { type: 'string', minLength: 3, maxLength: 20 },
    email: { type: 'string', },
    password: { type: 'string', minLength: 6 },
    phoneNumber: {type: "string",minLength: 11}
  },
  required: ['username', 'email', 'password','phoneNumber'],
  additionalProperties: false,
};

// Create AJV instance
const ajv = new Ajv();

// Compile schema
const validate = ajv.compile(userSchema);

// Exporting the validation function
module.exports = validate;
