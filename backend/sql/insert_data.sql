-- Insert sample users
INSERT INTO users (username, email, password_hash) VALUES
('john_doe', 'john@example.com', 'hashed_password_1'),
('jane_smith', 'jane@example.com', 'hashed_password_2'),
('mike_wilson', 'mike@example.com', 'hashed_password_3'),
('sarah_jones', 'sarah@example.com', 'hashed_password_4');

-- Insert sample products
INSERT INTO products (user_id, title, description, price, category, condition, location, image_url) VALUES
(1, 'iPhone 13 Pro', 'Like new iPhone 13 Pro 256GB', 799.99, 'Electronics', 'Like New', 'New York, NY', 'https://example.com/iphone.jpg'),
(2, 'Vintage Leather Jacket', 'Authentic 1980s leather jacket', 150.00, 'Clothing', 'Good', 'Los Angeles, CA', 'https://example.com/jacket.jpg'),
(3, 'Coffee Table', 'Modern glass coffee table, 48x24 inches', 120.00, 'Furniture', 'Excellent', 'Chicago, IL', ''),
(1, 'Nintendo Switch', 'Nintendo Switch with 2 controllers and 3 games', 250.00, 'Gaming', 'Good', 'New York, NY', ''),
(4, 'Designer Handbag', 'Louis Vuitton Neverfull MM, authentic', 1200.00, 'Fashion', 'Like New', 'Miami, FL', '');

-- Insert sample orders
INSERT INTO orders (buyer_id, seller_id, product_id, status) VALUES
(2, 1, 1, 'completed'),
(3, 2, 2, 'pending'),
(1, 4, 5, 'completed'),
(4, 3, 3, 'completed');

-- Insert sample reviews
INSERT INTO reviews (reviewer_id, reviewed_id, order_id, rating, comment) VALUES
(2, 1, 1, 5, 'Great seller! Phone was exactly as described.'),
(1, 4, 3, 4, 'Beautiful handbag, authentic as described.'),
(4, 3, 4, 5, 'Table was in perfect condition, fast shipping!');
