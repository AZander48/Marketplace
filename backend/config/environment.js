export const environments = {
  development: {
    baseUrl: 'http://localhost:3000',
    apiUrl: 'http://localhost:3000/api'
  },
  production: {
    baseUrl: 'https://marketplace-backend-jv7c.onrender.com',
    apiUrl: 'https://marketplace-backend-jv7c.onrender.com/api'
  }
};

export const currentEnvironment = process.env.NODE_ENV || 'development';

export const config = environments[currentEnvironment]; 