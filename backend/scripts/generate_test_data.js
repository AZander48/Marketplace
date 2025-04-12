import bcrypt from 'bcrypt';

const password = 'password123'; // This will be the password for all test users

async function generateTestData() {
  const hashedPassword = await bcrypt.hash(password, 10);
  
  console.log('-- Test users with password: password123');
  console.log(`INSERT INTO users (username, email, password_hash) VALUES`);
  console.log(`('john_doe', 'john@example.com', '${hashedPassword}'),`);
  console.log(`('jane_smith', 'jane@example.com', '${hashedPassword}'),`);
  console.log(`('mike_wilson', 'mike@example.com', '${hashedPassword}'),`);
  console.log(`('sarah_jones', 'sarah@example.com', '${hashedPassword}');`);
}

generateTestData().catch(console.error); 