-- Enable pgcrypto extension for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert default locations
INSERT INTO locations (name, description) VALUES
    ('New York, NY', 'New York City, New York'),
    ('Los Angeles, CA', 'Los Angeles, California'),
    ('Chicago, IL', 'Chicago, Illinois'),
    ('Miami, FL', 'Miami, Florida'),
    ('San Francisco, CA', 'San Francisco, California'),
    ('Seattle, WA', 'Seattle, Washington'),
    ('Austin, TX', 'Austin, Texas'),
    ('Boston, MA', 'Boston, Massachusetts'),
    ('Washington, DC', 'Washington, D.C.');

-- Insert default categories
INSERT INTO categories (name, icon, description) VALUES
    ('Electronics', 'devices', 'Phones, laptops, tablets, and other electronic devices'),
    ('Fashion', 'clothes', 'Clothing, shoes, and accessories'),
    ('Home & Garden', 'home', 'Furniture, decor, and garden items'),
    ('Vehicles', 'car', 'Cars, motorcycles, and other vehicles'),
    ('Sports', 'sports', 'Sports equipment and gear'),
    ('Books', 'book', 'Books, magazines, and other reading materials'),
    ('Toys & Games', 'toys', 'Toys, games, and entertainment items'),
    ('Beauty & Health', 'beauty', 'Beauty products and health items'),
    ('Pets', 'pets', 'Pet supplies and accessories'),
    ('Other', 'other', 'Other miscellaneous items')
ON CONFLICT (name) DO NOTHING;

-- Insert sample users with properly hashed passwords
INSERT INTO users (username, email, password_hash) VALUES
('john_doe', 'john@example.com', crypt('password123', gen_salt('bf'))),
('jane_smith', 'jane@example.com', crypt('password123', gen_salt('bf'))),
('mike_wilson', 'mike@example.com', crypt('password123', gen_salt('bf'))),
('sarah_jones', 'sarah@example.com', crypt('password123', gen_salt('bf')));

-- Insert sample products
INSERT INTO products (user_id, title, description, price, category_id, condition, location_id, image_url) VALUES
(1, 'iPhone 13 Pro', 'Like new iPhone 13 Pro 256GB', 799.99, 1, 'Like New', 1, 'https://example.com/iphone.jpg'),
(2, 'Vintage Leather Jacket', 'Authentic 1980s leather jacket', 150.00, 2, 'Good', 2, 'https://example.com/jacket.jpg'),
(3, 'Coffee Table', 'Modern glass coffee table, 48x24 inches', 120.00, 3, 'Excellent', 3, ''),
(1, 'Nintendo Switch', 'Nintendo Switch with 2 controllers and 3 games', 250.00, 4, 'Good', 4, ''),
(4, 'Designer Handbag', 'Louis Vuitton Neverfull MM, authentic', 1200.00, 5, 'Like New', 5, '');

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

    -- Insert default notifications
INSERT INTO notifications (user_id, type, title, message, related_id, related_type, is_read) VALUES
    (1, 'Welcome to the platform!', 'Welcome to the platform!', 'Welcome to the platform!', NULL, NULL, FALSE),
    (2, 'You have a new message.', 'You have a new message.', 'You have a new message.', NULL, NULL, FALSE),
    (3, 'Your order has been shipped.', 'Your order has been shipped.', 'Your order has been shipped.', NULL, NULL, FALSE),
    (4, 'Your account has been updated.', 'Your account has been updated.', 'Your account has been updated.', NULL, NULL, FALSE);

-- Insert default settings
INSERT INTO settings (user_id, notification_settings, saved_items, order_history, review_history) VALUES
    (1, '{"email": true, "push": false}', '[]', '[]', '[]'),
    (2, '{"email": false, "push": true}', '[]', '[]', '[]'),
    (3, '{"email": true, "push": true}', '[]', '[]', '[]'),
    (4, '{"email": false, "push": false}', '[]', '[]', '[]');

-- Insert default user interactions
INSERT INTO user_interactions (user_id, product_id, interaction_type) VALUES
    (1, 1, 'view'),
    (2, 2, 'like'),
    (3, 3, 'purchase'),
    (4, 4, 'message');

-- Insert default product popularity
INSERT INTO product_popularity (product_id, view_count, favorite_count, message_count, purchase_count) VALUES
    (1, 100, 20, 5, 1),
    (2, 50, 10, 3, 0),
    (3, 200, 30, 10, 2),
    (4, 150, 25, 7, 1);

-- Insert default user preferences
INSERT INTO user_preferences (user_id, preferred_categories, preferred_price_range, preferred_locations) VALUES
    (1, '["Electronics"]', '{"min": 500, "max": 1000}', '["New York, NY", "Los Angeles, CA"]'),
    (2, '["Fashion"]', '{"min": 100, "max": 500}', '["Los Angeles, CA", "San Francisco, CA"]'),
    (3, '["Furniture"]', '{"min": 50, "max": 200}', '["Chicago, IL", "Austin, TX"]'),
    (4, '["Toys & Games"]', '{"min": 10, "max": 50}', '["Miami, FL", "Seattle, WA"]');

-- Insert default user search history
INSERT INTO search_history (user_id, query, category, filters, result_count) VALUES
    (1, 'iPhone 13 Pro', 'Electronics', '{"min_price": 500, "max_price": 1000, "location": "New York, NY"}', 10),
    (2, 'Leather Jacket', 'Fashion', '{"min_price": 100, "max_price": 500, "location": "Los Angeles, CA"}', 5),
    (3, 'Coffee Table', 'Furniture', '{"min_price": 50, "max_price": 200, "location": "Chicago, IL"}', 3),
    (4, 'Louis Vuitton Handbag', 'Fashion', '{"min_price": 1000, "max_price": 2000, "location": "Miami, FL"}', 2);

-- Insert default reports
INSERT INTO reports (user_id, reported_user_id, report_type, validation, ban) VALUES
    (1, 2, 'spam', FALSE, FALSE),
    (2, 3, 'inappropriate content', TRUE, TRUE),
    (3, 4, 'fraud', FALSE, FALSE),
    (4, 1, 'spam', TRUE, FALSE);

-- Insert default bans
INSERT INTO bans (user_id, reason) VALUES
    (2, 'Spamming and inappropriate content'),
    (3, 'Fraudulent activity and spamming');

-- Insert default user suspensions
INSERT INTO user_suspensions (user_id, suspension_type, reason) VALUES
    (2, 'spam', 'Spamming and inappropriate content'),
    (3, 'fraud', 'Fraudulent activity and spamming');

-- Insert default product reports
/*INSERT INTO product_reports (product_id, reporter_id, report_type, validation, ban) VALUES
    (1, 2, 'spam', FALSE, FALSE),
    (2, 3, 'inappropriate content', TRUE, TRUE),
    (3, 4, 'fraud', FALSE, FALSE),
    (4, 1, 'spam', TRUE, FALSE);*/

