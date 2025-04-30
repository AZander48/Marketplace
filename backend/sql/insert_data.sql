-- Enable pgcrypto extension for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert countries first
INSERT INTO countries (name, code) VALUES
('United States', 'US'),
('Canada', 'CA'),
('United Kingdom', 'GB'),
('Australia', 'AU');

-- Insert states for United States
INSERT INTO states (country_id, name, code) VALUES
(1, 'Alabama', 'AL'),
(1, 'Alaska', 'AK'),
(1, 'Arizona', 'AZ'),
(1, 'Arkansas', 'AR'),
(1, 'California', 'CA'),
(1, 'Colorado', 'CO'),
(1, 'Connecticut', 'CT'),
(1, 'Delaware', 'DE'),
(1, 'Florida', 'FL'),
(1, 'Georgia', 'GA'),
(1, 'Hawaii', 'HI'),
(1, 'Idaho', 'ID'),
(1, 'Illinois', 'IL'),
(1, 'Indiana', 'IN'),
(1, 'Iowa', 'IA'),
(1, 'Kansas', 'KS'),
(1, 'Kentucky', 'KY'),
(1, 'Louisiana', 'LA'),
(1, 'Maine', 'ME'),
(1, 'Maryland', 'MD'),
(1, 'Massachusetts', 'MA'),
(1, 'Michigan', 'MI'),
(1, 'Minnesota', 'MN'),
(1, 'Mississippi', 'MS'),
(1, 'Missouri', 'MO'),
(1, 'Montana', 'MT'),
(1, 'Nebraska', 'NE'),
(1, 'Nevada', 'NV'),
(1, 'New Hampshire', 'NH'),
(1, 'New Jersey', 'NJ'),
(1, 'New Mexico', 'NM'),
(1, 'New York', 'NY'),
(1, 'North Carolina', 'NC'),
(1, 'North Dakota', 'ND'),
(1, 'Ohio', 'OH'),
(1, 'Oklahoma', 'OK'),
(1, 'Oregon', 'OR'),
(1, 'Pennsylvania', 'PA'),
(1, 'Rhode Island', 'RI'),
(1, 'South Carolina', 'SC'),
(1, 'South Dakota', 'SD'),
(1, 'Tennessee', 'TN'),
(1, 'Texas', 'TX'),
(1, 'Utah', 'UT'),
(1, 'Vermont', 'VT'),
(1, 'Virginia', 'VA'),
(1, 'Washington', 'WA'),
(1, 'West Virginia', 'WV'),
(1, 'Wisconsin', 'WI'),
(1, 'Wyoming', 'WY'),
(1, 'District of Columbia', 'DC');

-- Insert provinces and territories for Canada
INSERT INTO states (country_id, name, code) VALUES
(2, 'Alberta', 'AB'),
(2, 'British Columbia', 'BC'),
(2, 'Manitoba', 'MB'),
(2, 'New Brunswick', 'NB'),
(2, 'Newfoundland and Labrador', 'NL'),
(2, 'Northwest Territories', 'NT'),
(2, 'Nova Scotia', 'NS'),
(2, 'Nunavut', 'NU'),
(2, 'Ontario', 'ON'),
(2, 'Prince Edward Island', 'PE'),
(2, 'Quebec', 'QC'),
(2, 'Saskatchewan', 'SK'),
(2, 'Yukon', 'YT');

-- Insert countries for United Kingdom
INSERT INTO states (country_id, name, code) VALUES
(3, 'England', 'ENG'),
(3, 'Scotland', 'SCT'),
(3, 'Wales', 'WLS'),
(3, 'Northern Ireland', 'NIR');

-- Insert states and territories for Australia
INSERT INTO states (country_id, name, code) VALUES
(4, 'Australian Capital Territory', 'ACT'),
(4, 'New South Wales', 'NSW'),
(4, 'Northern Territory', 'NT'),
(4, 'Queensland', 'QLD'),
(4, 'South Australia', 'SA'),
(4, 'Tasmania', 'TAS'),
(4, 'Victoria', 'VIC'),
(4, 'Western Australia', 'WA');

-- Note: Cities are not pre-populated. They will be added dynamically as users enter their locations.
-- This approach allows for:
-- 1. User flexibility in entering their exact city
-- 2. Automatic creation of new cities as needed
-- 3. Proper linking to states/provinces
-- 4. Prevention of duplicate cities within the same state

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
    ('Other', 'other', 'Other miscellaneous items');

-- Insert default vehicle types
INSERT INTO vehicle_types (name) VALUES
('Car'),
('Motorcycle'),
('Truck'),
('Boat'),
('Other');

-- Insert default vehicle makes
INSERT INTO vehicle_makes (name, type_id) VALUES
('Honda', 1),
('Toyota', 1),
('Tesla', 1),
('BMW', 1),
('Harley-Davidson', 2),
('Kawasaki', 2),
('Polaris', 3),
('Yamaha', 2),
('Other', 4);

-- Insert default vehicle models
INSERT INTO vehicle_models (name, make_id) VALUES
('Civic', 1),
('Camry', 1),
('Model 3', 1),
('320i', 1),
('Ninja 400', 2),
('Polaris RZR', 3),
('FZ1', 2),
('Other', 4);

-- Insert default vehicle submodels
INSERT INTO vehicle_submodels (name, model_id) VALUES
('2.0L Turbo', 1),
('3.5L V6', 1),
('Dual Motor', 1),
('2.0L TwinPower', 1),
('400cc', 2),
('RZR 1000', 3),
('FZ1-S', 2),
('Other', 4);

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

-- Insert sample messages
INSERT INTO messages (sender_id, receiver_id, product_id, message) VALUES
(1, 2, 1, 'Hello, I''m interested in your iPhone 13 Pro. Can you tell me more about it?'),
(2, 1, 1, 'Sure, I can send you more details. What''s your name?'),
(1, 2, 1, 'My name is John Doe. Can you send me the details?'),
(2, 1, 1, 'Absolutely, I''ll send you the details right away.');

-- Insert default garage items
INSERT INTO garage_items (user_id, name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, is_primary) VALUES
(1, '2021 Honda Civic', '2021 Honda Civic, 2.0L, automatic transmission, 182 hp', 'https://example.com/honda_civic.jpg', 1, 2021, 1, 1, 1, true),
(2, '2019 Toyota Camry', '2019 Toyota Camry, 3.5L, automatic transmission, 301 hp', 'https://example.com/toyota_camry.jpg', 1, 2019, 2, 2, 2, false),
(3, '2020 Tesla Model 3', '2020 Tesla Model 3, 283 hp', 'https://example.com/tesla_model_3.jpg', 1, 2020, 3, 3, 3, false),
(4, '2018 BMW 320i', '2018 BMW 320i, 2.0L, automatic transmission, 248 hp', 'https://example.com/bmw_320i.jpg', 1, 2018, 4, 4, 4, false);
