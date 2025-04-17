-- Enable pgcrypto extension for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- Insert countries
INSERT INTO countries (name, code) VALUES
('United States', 'US'),
('Canada', 'CA'),
('United Kingdom', 'GB'),
('Australia', 'AU');

-- Insert states for United States
INSERT INTO states (country_id, name, code) VALUES
(1, 'New York', 'NY'),
(1, 'California', 'CA'),
(1, 'Texas', 'TX'),
(1, 'Florida', 'FL'),
(1, 'Illinois', 'IL');

-- Insert states for Canada
INSERT INTO states (country_id, name, code) VALUES
(2, 'Ontario', 'ON'),
(2, 'Quebec', 'QC'),
(2, 'British Columbia', 'BC'),
(2, 'Alberta', 'AB');

-- Insert states for United Kingdom
INSERT INTO states (country_id, name, code) VALUES
(3, 'England', 'ENG'),
(3, 'Scotland', 'SCT'),
(3, 'Wales', 'WLS'),
(3, 'Northern Ireland', 'NIR');

-- Insert states for Australia
INSERT INTO states (country_id, name, code) VALUES
(4, 'New South Wales', 'NSW'),
(4, 'Victoria', 'VIC'),
(4, 'Queensland', 'QLD'),
(4, 'Western Australia', 'WA');

-- Insert major cities for US states
INSERT INTO cities (state_id, name) VALUES
-- New York cities
(1, 'New York City'),
(1, 'Buffalo'),
(1, 'Rochester'),
-- California cities
(2, 'Los Angeles'),
(2, 'San Francisco'),
(2, 'San Diego'),
-- Texas cities
(3, 'Houston'),
(3, 'Dallas'),
(3, 'Austin'),
-- Florida cities
(4, 'Miami'),
(4, 'Orlando'),
(4, 'Tampa'),
-- Illinois cities
(5, 'Chicago'),
(5, 'Springfield'),
(5, 'Rockford');

-- Insert major cities for Canadian provinces
INSERT INTO cities (state_id, name) VALUES
-- Ontario cities
(6, 'Toronto'),
(6, 'Ottawa'),
(6, 'Hamilton'),
-- Quebec cities
(7, 'Montreal'),
(7, 'Quebec City'),
(7, 'Laval'),
-- British Columbia cities
(8, 'Vancouver'),
(8, 'Victoria'),
(8, 'Surrey'),
-- Alberta cities
(9, 'Calgary'),
(9, 'Edmonton'),
(9, 'Red Deer');

-- Insert major cities for UK countries
INSERT INTO cities (state_id, name) VALUES
-- England cities
(10, 'London'),
(10, 'Manchester'),
(10, 'Birmingham'),
-- Scotland cities
(11, 'Edinburgh'),
(11, 'Glasgow'),
(11, 'Aberdeen'),
-- Wales cities
(12, 'Cardiff'),
(12, 'Swansea'),
(12, 'Newport'),
-- Northern Ireland cities
(13, 'Belfast'),
(13, 'Derry'),
(13, 'Lisburn');

-- Insert major cities for Australian states
INSERT INTO cities (state_id, name) VALUES
-- New South Wales cities
(14, 'Sydney'),
(14, 'Newcastle'),
(14, 'Wollongong'),
-- Victoria cities
(15, 'Melbourne'),
(15, 'Geelong'),
(15, 'Ballarat'),
-- Queensland cities
(16, 'Brisbane'),
(16, 'Gold Coast'),
(16, 'Sunshine Coast'),
-- Western Australia cities
(17, 'Perth'),
(17, 'Fremantle'),
(17, 'Mandurah');

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
INSERT INTO users (username, email, password_hash, city_id, profile_image_url, bio, phone_number, is_verified) VALUES
('john_doe', 'john@example.com', crypt('password123', gen_salt('bf')), 1, 'https://example.com/profiles/john.jpg', 'Tech enthusiast and gadget collector', '+1 212-555-1234', true),
('jane_smith', 'jane@example.com', crypt('password123', gen_salt('bf')), 2, 'https://example.com/profiles/jane.jpg', 'Fashion designer and vintage collector', '+1 310-555-5678', true),
('mike_wilson', 'mike@example.com', crypt('password123', gen_salt('bf')), 3, 'https://example.com/profiles/mike.jpg', 'Sports equipment seller and fitness trainer', '+1 312-555-9012', true),
('sarah_jones', 'sarah@example.com', crypt('password123', gen_salt('bf')), 4, 'https://example.com/profiles/sarah.jpg', 'Art collector and gallery owner', '+1 713-555-3456', true);

-- Insert sample products
INSERT INTO products (user_id, title, description, price, category_id, condition, city_id, image_url) VALUES
(1, 'iPhone 13 Pro', 'Like new, used for 2 months', 899.99, 1, 'Like New', 1, 'https://example.com/iphone.jpg'),
(2, 'MacBook Pro', '2021 model, 16GB RAM', 1299.99, 1, 'Like New', 2, 'https://example.com/macbook.jpg'),
(3, 'Nike Air Max', 'Size 10, never worn', 129.99, 2, 'New', 3, 'https://example.com/nike.jpg'),
(4, 'Sony Headphones', 'Noise cancelling, wireless', 299.99, 1, 'Like New', 4, 'https://example.com/sony.jpg'),
(1, 'Basketball', 'Professional basketball, never used', 29.99, 4, 'New', 5, 'https://example.com/basketball.jpg'),
(2, 'Programming Book', 'Learn Flutter in 30 days', 49.99, 5, 'Like New', 6, 'https://example.com/book.jpg');

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

-- Insert products with city references
INSERT INTO products (user_id, title, description, price, category_id, city_id, image_url) VALUES
(1, 'iPhone 13 Pro', 'Brand new iPhone 13 Pro, 256GB', 999.99, 1, 1, 'https://example.com/iphone.jpg'),
(2, 'Designer Dress', 'Beautiful evening dress, size M', 199.99, 2, 3, 'https://example.com/dress.jpg'),
(3, 'Garden Tools Set', 'Complete set of gardening tools', 79.99, 3, 9, 'https://example.com/tools.jpg'),
(1, 'Basketball', 'Professional basketball, never used', 29.99, 4, 5, 'https://example.com/basketball.jpg'),
(2, 'Programming Book', 'Learn Flutter in 30 days', 49.99, 5, 7, 'https://example.com/book.jpg');

-- Add user location preferences
INSERT INTO user_location_preferences (user_id, city_id, is_primary) VALUES
-- John Doe's preferences (New York primary, Los Angeles secondary)
(1, 1, true),
(1, 2, false),
-- Jane Smith's preferences (Los Angeles primary, New York secondary)
(2, 2, true),
(2, 1, false),
-- Mike Wilson's preferences (Chicago primary, Houston secondary)
(3, 3, true),
(3, 4, false),
-- Sarah Jones's preferences (Houston primary, Chicago secondary)
(4, 4, true),
(4, 3, false);

