import { query } from '../config/database.js';

async function checkUsers() {
  try {
    const result = await query('SELECT id, username, email FROM users');
    console.log('Users in database:');
    console.log(result.rows);
  } catch (error) {
    console.error('Error checking users:', error);
  }
}

checkUsers(); 