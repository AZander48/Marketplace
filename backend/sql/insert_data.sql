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

-- Insert minimal cities for sample users
INSERT INTO cities (id, name, state_id) VALUES
(1, 'New York', 33),  -- New York, NY
(2, 'Los Angeles', 5), -- Los Angeles, CA
(3, 'Chicago', 13),   -- Chicago, IL
(4, 'Houston', 44),   -- Houston, TX
(5, 'San Francisco', 5), -- San Francisco, CA
(6, 'Miami', 10),     -- Miami, FL
(7, 'Seattle', 48),   -- Seattle, WA
(8, 'Atlanta', 11),   -- Atlanta, GA
(9, 'Portland', 38),  -- Portland, OR
(10, 'Phoenix', 3),   -- Phoenix, AZ
(11, 'Denver', 6),    -- Denver, CO
(12, 'Boston', 22),   -- Boston, MA
(13, 'Dallas', 44),   -- Dallas, TX
(14, 'Columbus', 36), -- Columbus, OH
(15, 'San Jose', 5),  -- San Jose, CA
(16, 'Austin', 44),   -- Austin, TX (for Olivia)
(17, 'Las Vegas', 28), -- Las Vegas, NV (for William)
(18, 'San Diego', 5), -- San Diego, CA (for Isabella)
(19, 'Orlando', 10),  -- Orlando, FL (for Daniel)
(20, 'Eugene', 38);   -- Eugene, OR (for Emily)

-- Note: Additional cities will be added dynamically as users enter their locations.
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
    ('Vehicle Parts', 'build', 'Automotive parts and components'),
    ('Engine Parts', 'engineering', 'Engine components, pistons, crankshafts, and related parts'),
    ('Transmission Parts', 'settings', 'Transmission components, gears, clutches, and related parts'),
    ('Suspension Parts', 'air', 'Shocks, struts, springs, and suspension components'),
    ('Brake Parts', 'stop_circle', 'Brake pads, rotors, calipers, and brake system components'),
    ('Electrical Parts', 'electric_bolt', 'Batteries, alternators, starters, and electrical components'),
    ('Interior Parts', 'chair', 'Seats, dashboards, consoles, and interior components'),
    ('Exterior Parts', 'directions_car', 'Body panels, bumpers, lights, and exterior components'),
    ('Wheels & Tires', 'tire_repair', 'Wheels, tires, rims, and related components'),
    ('Performance Parts', 'speed', 'Performance upgrades, turbochargers, and performance components'),
    ('Maintenance Parts', 'build_circle', 'Filters, fluids, belts, and maintenance components'),
    ('Musical Instruments', 'music_note', 'Guitars, pianos, drums, and other musical instruments'),
    ('Art & Crafts', 'palette', 'Art supplies, craft materials, and handmade items'),
    ('Jewelry', 'diamond', 'Necklaces, rings, watches, and other jewelry items'),
    ('Collectibles', 'star', 'Trading cards, figurines, and collectible items'),
    ('Office Supplies', 'work', 'Stationery, paper products, and office equipment'),
    ('Food & Beverages', 'restaurant', 'Gourmet foods, beverages, and cooking supplies'),
    ('Baby & Kids', 'child_care', 'Baby gear, children''s clothing, and toys'),
    ('Health & Fitness', 'fitness_center', 'Exercise equipment, supplements, and wellness products'),
    ('Garden & Outdoor', 'yard', 'Plants, outdoor furniture, and gardening supplies'),
    ('Tools & Hardware', 'handyman', 'Power tools, hand tools, and hardware supplies'),
    ('Photography', 'camera_alt', 'Cameras, lenses, and photography equipment'),
    ('Computers & Accessories', 'computer', 'PCs, laptops, and computer peripherals'),
    ('Gaming', 'sports_esports', 'Video games, consoles, and gaming accessories'),
    ('Antiques', 'museum', 'Vintage items, antiques, and collectibles'),
    ('Party Supplies', 'celebration', 'Decorations, party favors, and event supplies'),
    ('Travel Gear', 'luggage', 'Luggage, backpacks, and travel accessories'),
    ('Pet Supplies', 'pets', 'Pet food, toys, and accessories'),
    ('Home Improvement', 'home_repair_service', 'Building materials and home renovation supplies'),
    ('Industrial & Scientific', 'science', 'Industrial equipment and scientific instruments'),
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
('Ford', 1),
('Chevrolet', 1),
('Dodge', 1),
('Nissan', 1),
('Subaru', 1),
('Mazda', 1),
('Audi', 1),
('Mercedes-Benz', 1),
('Lexus', 1),
('Hyundai', 1),
('Kia', 1),
('Volkswagen', 1),
('Porsche', 1),
('Jeep', 1),
('GMC', 1),
('Ram', 3),
('Buick', 1),
('Cadillac', 1),
('Lincoln', 1),
('Acura', 1),
('Infiniti', 1),
('Genesis', 1),
('Suzuki', 2),
('Triumph', 2),
('Ducati', 2),
('Indian', 2),
('Can-Am', 3),
('Arctic Cat', 3),
('Other', 4);

-- Insert default vehicle models
INSERT INTO vehicle_models (name, make_id) VALUES
-- Honda Models
('Civic', 1),
('Accord', 1),
('CR-V', 1),
('Pilot', 1),
('Odyssey', 1),
('Fit', 1),
('HR-V', 1),
('Ridgeline', 1),
('Insight', 1),
('Passport', 1),

-- Toyota Models
('Camry', 2),
('Corolla', 2),
('RAV4', 2),
('Highlander', 2),
('Tacoma', 2),
('Tundra', 2),
('4Runner', 2),
('Sienna', 2),
('Prius', 2),
('Avalon', 2),

-- Tesla Models
('Model 3', 3),
('Model S', 3),
('Model X', 3),
('Model Y', 3),
('Cybertruck', 3),

-- BMW Models
('320i', 4),
('330i', 4),
('M3', 4),
('X3', 4),
('X5', 4),
('M5', 4),
('Z4', 4),
('i3', 4),
('i8', 4),
('M4', 4),

-- Harley-Davidson Models
('Street Bob', 5),
('Road King', 5),
('Sportster', 5),
('Fat Boy', 5),
('Heritage Classic', 5),
('Road Glide', 5),
('Street Glide', 5),
('Softail', 5),
('Electra Glide', 5),
('Iron 883', 5),

-- Kawasaki Models
('Ninja 400', 6),
('Ninja 650', 6),
('Z650', 6),
('Versys 650', 6),
('Concours 14', 6),
('Vulcan S', 6),
('KLR650', 6),
('ZX-6R', 6),
('ZX-10R', 6),
('KLX450R', 6),

-- Polaris Models
('RZR 1000', 7),
('RZR XP 1000', 7),
('RZR Turbo', 7),
('Ranger 1000', 7),
('Sportsman 850', 7),
('Scrambler 1000', 7),
('General 1000', 7),
('Ace 900', 7),
('Outlaw 1000', 7),
('RZR 200', 7),

-- Yamaha Models
('FZ1', 8),
('MT-07', 8),
('MT-09', 8),
('R1', 8),
('R6', 8),
('YZF-R3', 8),
('FJR1300', 8),
('VMAX', 8),
('Bolt', 8),
('V Star 650', 8),

-- Ford Models
('F-150', 9),
('Mustang', 9),
('Explorer', 9),
('Escape', 9),
('Edge', 9),
('Ranger', 9),
('Expedition', 9),
('F-250', 9),
('Bronco', 9),
('Maverick', 9),

-- Chevrolet Models
('Silverado 1500', 10),
('Camaro', 10),
('Equinox', 10),
('Tahoe', 10),
('Corvette', 10),
('Malibu', 10),
('Traverse', 10),
('Colorado', 10),
('Suburban', 10),
('Blazer', 10),

-- Other Models
('Other', 37);

-- Insert default vehicle submodels
INSERT INTO vehicle_submodels (name, model_id) VALUES
-- Honda Civic Submodels
('2.0L Turbo', 1),
('1.5L Turbo', 1),
('2.0L Natural', 1),
('Type R', 1),
('Si', 1),
('Sport', 1),
('Touring', 1),
('LX', 1),
('EX', 1),
('EX-L', 1),

-- Toyota Camry Submodels
('3.5L V6', 11),
('2.5L 4-Cylinder', 11),
('Hybrid', 11),
('SE', 11),
('XSE', 11),
('LE', 11),
('XLE', 11),
('TRD', 11),
('Nightshade', 11),
('AWD', 11),

-- Tesla Model 3 Submodels
('Dual Motor', 21),
('Performance', 21),
('Long Range', 21),
('Standard Range', 21),
('Standard Range Plus', 21),

-- BMW 320i Submodels
('2.0L TwinPower', 26),
('M Sport', 26),
('xDrive', 26),
('Sport Line', 26),
('Luxury Line', 26),
('Modern Line', 26),
('First Edition', 26),
('M Performance', 26),
('Shadow Edition', 26),
('Black Edition', 26),

-- Harley Street Bob Submodels
('107ci', 31),
('114ci', 31),
('Milwaukee-Eight', 31),
('FXBB', 31),
('Special', 31),
('Black', 31),
('Denim', 31),
('Iron', 31),
('Stealth', 31),
('Custom', 31),

-- Kawasaki Ninja 400 Submodels
('400cc', 36),
('ABS', 36),
('KRT Edition', 36),
('Special Edition', 36),
('Performance', 36),
('Track', 36),
('Street', 36),
('Custom', 36),
('Limited', 36),
('Race', 36),

-- Polaris RZR 1000 Submodels
('RZR 1000', 41),
('RZR 1000S', 41),
('RZR 1000XP', 41),
('RZR 1000XP4', 41),
('RZR 1000 Trail', 41),
('RZR 1000 Sport', 41),
('RZR 1000 Premium', 41),
('RZR 1000 Ultimate', 41),
('RZR 1000 Rockford', 41),
('RZR 1000 Dynamix', 41),

-- Yamaha FZ1 Submodels
('FZ1-S', 46),
('FZ1-N', 46),
('FZ1-S ABS', 46),
('FZ1-N ABS', 46),
('FZ1-S Touring', 46),
('FZ1-N Touring', 46),
('FZ1-S Sport', 46),
('FZ1-N Sport', 46),
('FZ1-S Custom', 46),
('FZ1-N Custom', 46),

-- Ford F-150 Submodels
('3.5L EcoBoost', 51),
('5.0L V8', 51),
('2.7L EcoBoost', 51),
('3.0L Power Stroke', 51),
('Raptor', 51),
('Platinum', 51),
('Limited', 51),
('King Ranch', 51),
('Lariat', 51),
('XLT', 51),

-- Chevrolet Silverado Submodels
('5.3L V8', 61),
('6.2L V8', 61),
('3.0L Duramax', 61),
('2.7L Turbo', 61),
('High Country', 61),
('LTZ', 61),
('LT', 61),
('Custom', 61),
('Work Truck', 61),
('Trail Boss', 61),

-- Other Submodels
('Other', 91);

-- Insert sample users with properly hashed passwords
INSERT INTO users (username, email, password_hash, city_id, profile_image_url, bio, phone_number, is_verified) VALUES
('john_doe', 'john@example.com', crypt('password123', gen_salt('bf')), 1, 'https://example.com/profiles/john.jpg', 'Tech enthusiast and gadget collector', '+1 212-555-1234', true),
('jane_smith', 'jane@example.com', crypt('password123', gen_salt('bf')), 2, 'https://example.com/profiles/jane.jpg', 'Fashion designer and vintage collector', '+1 310-555-5678', true),
('mike_wilson', 'mike@example.com', crypt('password123', gen_salt('bf')), 3, 'https://example.com/profiles/mike.jpg', 'Sports equipment seller and fitness trainer', '+1 312-555-9012', true),
('sarah_jones', 'sarah@example.com', crypt('password123', gen_salt('bf')), 4, 'https://example.com/profiles/sarah.jpg', 'Art collector and gallery owner', '+1 713-555-3456', true),
('alex_chen', 'alex@example.com', crypt('password123', gen_salt('bf')), 5, 'https://example.com/profiles/alex.jpg', 'Car enthusiast and mechanic', '+1 415-555-7890', true),
('emma_rodriguez', 'emma@example.com', crypt('password123', gen_salt('bf')), 6, 'https://example.com/profiles/emma.jpg', 'Vintage car restorer', '+1 305-555-2345', true),
('david_kim', 'david@example.com', crypt('password123', gen_salt('bf')), 7, 'https://example.com/profiles/david.jpg', 'Auto parts specialist', '+1 206-555-6789', true),
('lisa_patel', 'lisa@example.com', crypt('password123', gen_salt('bf')), 8, 'https://example.com/profiles/lisa.jpg', 'Classic car collector', '+1 404-555-0123', true),
('james_wilson', 'james@example.com', crypt('password123', gen_salt('bf')), 9, 'https://example.com/profiles/james.jpg', 'Performance parts dealer', '+1 503-555-4567', true),
('maria_garcia', 'maria@example.com', crypt('password123', gen_salt('bf')), 10, 'https://example.com/profiles/maria.jpg', 'Auto repair shop owner', '+1 602-555-8901', true),
('robert_taylor', 'robert@example.com', crypt('password123', gen_salt('bf')), 11, 'https://example.com/profiles/robert.jpg', 'Motorcycle parts specialist', '+1 303-555-2345', true),
('sophie_martin', 'sophie@example.com', crypt('password123', gen_salt('bf')), 12, 'https://example.com/profiles/sophie.jpg', 'Car audio system expert', '+1 617-555-6789', true),
('michael_brown', 'michael@example.com', crypt('password123', gen_salt('bf')), 13, 'https://example.com/profiles/michael.jpg', 'Truck parts dealer', '+1 214-555-0123', true),
('anna_kowalski', 'anna@example.com', crypt('password123', gen_salt('bf')), 14, 'https://example.com/profiles/anna.jpg', 'Electric vehicle specialist', '+1 312-555-4567', true),
('thomas_nguyen', 'thomas@example.com', crypt('password123', gen_salt('bf')), 15, 'https://example.com/profiles/thomas.jpg', 'Import car parts dealer', '+1 408-555-8901', true),
('olivia_lee', 'olivia@example.com', crypt('password123', gen_salt('bf')), 16, 'https://example.com/profiles/olivia.jpg', 'Luxury car parts specialist', '+1 212-555-2345', true),
('william_clark', 'william@example.com', crypt('password123', gen_salt('bf')), 17, 'https://example.com/profiles/william.jpg', 'Off-road parts dealer', '+1 303-555-6789', true),
('isabella_moore', 'isabella@example.com', crypt('password123', gen_salt('bf')), 18, 'https://example.com/profiles/isabella.jpg', 'Vintage motorcycle collector', '+1 415-555-0123', true),
('daniel_white', 'daniel@example.com', crypt('password123', gen_salt('bf')), 19, 'https://example.com/profiles/daniel.jpg', 'Performance tuning expert', '+1 305-555-4567', true),
('emily_davis', 'emily@example.com', crypt('password123', gen_salt('bf')), 20, 'https://example.com/profiles/emily.jpg', 'Auto body parts specialist', '+1 206-555-8901', true);

-- Insert sample products
INSERT INTO products (user_id, title, description, price, category_id, condition, city_id, image_url) VALUES
-- Electronics (Category 1)
(1, 'iPhone 13 Pro', 'Like new, used for 2 months', 899.99, 1, 'Like New', 1, 'https://example.com/iphone.jpg'),
(2, 'MacBook Pro 2021', '16GB RAM, 512GB SSD', 1299.99, 1, 'Like New', 2, 'https://example.com/macbook.jpg'),
(3, 'Sony WH-1000XM4', 'Noise cancelling headphones', 299.99, 1, 'New', 3, 'https://example.com/sony.jpg'),
(4, 'Samsung Galaxy S21', 'Unlocked, perfect condition', 699.99, 1, 'Like New', 4, 'https://example.com/samsung.jpg'),
(5, 'iPad Pro 12.9', '2021 model, 256GB', 899.99, 1, 'New', 5, 'https://example.com/ipad.jpg'),

-- Fashion (Category 2)
(6, 'Leather Jacket', 'Genuine leather, size M', 199.99, 2, 'Like New', 6, 'https://example.com/jacket.jpg'),
(7, 'Designer Watch', 'Swiss made, automatic', 599.99, 2, 'New', 7, 'https://example.com/watch.jpg'),
(8, 'Running Shoes', 'Nike Air Max, size 10', 129.99, 2, 'New', 8, 'https://example.com/shoes.jpg'),
(9, 'Designer Bag', 'Louis Vuitton, authentic', 1299.99, 2, 'Like New', 9, 'https://example.com/bag.jpg'),
(10, 'Sunglasses', 'Ray-Ban Aviator', 149.99, 2, 'New', 10, 'https://example.com/sunglasses.jpg'),

-- Home & Garden (Category 3)
(11, 'Coffee Table', 'Modern design, glass top', 299.99, 3, 'Like New', 11, 'https://example.com/table.jpg'),
(12, 'Garden Tools Set', 'Complete set, 12 pieces', 79.99, 3, 'New', 12, 'https://example.com/tools.jpg'),
(13, 'Outdoor Furniture', 'Patio set, 6 pieces', 499.99, 3, 'Like New', 13, 'https://example.com/furniture.jpg'),
(14, 'Plant Collection', 'Indoor plants, 5 varieties', 89.99, 3, 'New', 14, 'https://example.com/plants.jpg'),
(15, 'Smart Home Hub', 'Google Nest Hub', 99.99, 3, 'New', 15, 'https://example.com/hub.jpg'),

-- Vehicle Parts (Category 10)
(16, 'Engine Block', 'V8 engine block, rebuilt', 1999.99, 10, 'Used', 16, 'https://example.com/engine.jpg'),
(17, 'Transmission', 'Automatic transmission, low miles', 1499.99, 10, 'Used', 17, 'https://example.com/transmission.jpg'),
(18, 'Suspension Kit', 'Complete suspension upgrade', 899.99, 10, 'New', 18, 'https://example.com/suspension.jpg'),
(19, 'Brake System', 'Complete brake system, new', 599.99, 10, 'New', 19, 'https://example.com/brakes.jpg'),
(20, 'Electrical System', 'Complete wiring harness', 399.99, 10, 'New', 20, 'https://example.com/electrical.jpg'),

-- Engine Parts (Category 11)
(1, 'Pistons Set', 'Forged pistons, 4 cylinders', 499.99, 11, 'New', 1, 'https://example.com/pistons.jpg'),
(2, 'Crankshaft', 'Billet crankshaft, balanced', 899.99, 11, 'New', 2, 'https://example.com/crankshaft.jpg'),
(3, 'Camshaft', 'Performance camshaft', 399.99, 11, 'New', 3, 'https://example.com/camshaft.jpg'),
(4, 'Valve Set', 'Titanium valves, complete set', 299.99, 11, 'New', 4, 'https://example.com/valves.jpg'),
(5, 'Engine Bearings', 'Main and rod bearings, set', 149.99, 11, 'New', 5, 'https://example.com/bearings.jpg'),

-- Transmission Parts (Category 12)
(6, 'Clutch Kit', 'Performance clutch kit', 499.99, 12, 'New', 6, 'https://example.com/clutch.jpg'),
(7, 'Gear Set', 'Close ratio gear set', 799.99, 12, 'New', 7, 'https://example.com/gears.jpg'),
(8, 'Flywheel', 'Lightweight flywheel', 299.99, 12, 'New', 8, 'https://example.com/flywheel.jpg'),
(9, 'Shift Kit', 'Performance shift kit', 199.99, 12, 'New', 9, 'https://example.com/shiftkit.jpg'),
(10, 'Transmission Mount', 'Polyurethane mount', 49.99, 12, 'New', 10, 'https://example.com/mount.jpg'),

-- Suspension Parts (Category 13)
(11, 'Coilover Kit', 'Adjustable coilover kit', 1299.99, 13, 'New', 11, 'https://example.com/coilovers.jpg'),
(12, 'Sway Bar Set', 'Front and rear sway bars', 299.99, 13, 'New', 12, 'https://example.com/swaybars.jpg'),
(13, 'Control Arms', 'Adjustable control arms', 399.99, 13, 'New', 13, 'https://example.com/controlarms.jpg'),
(14, 'Shock Absorbers', 'Performance shocks, set of 4', 599.99, 13, 'New', 14, 'https://example.com/shocks.jpg'),
(15, 'Spring Set', 'Lowering springs, set of 4', 249.99, 13, 'New', 15, 'https://example.com/springs.jpg'),

-- Brake Parts (Category 14)
(16, 'Big Brake Kit', '6-piston caliper kit', 1499.99, 14, 'New', 16, 'https://example.com/brakekit.jpg'),
(17, 'Brake Pads', 'Performance brake pads, set', 199.99, 14, 'New', 17, 'https://example.com/pads.jpg'),
(18, 'Brake Rotors', 'Slotted rotors, set of 4', 399.99, 14, 'New', 18, 'https://example.com/rotors.jpg'),
(19, 'Brake Lines', 'Stainless steel lines, set', 149.99, 14, 'New', 19, 'https://example.com/brakelines.jpg'),
(20, 'Master Cylinder', 'Performance master cylinder', 299.99, 14, 'New', 20, 'https://example.com/mastercylinder.jpg'),

-- Electrical Parts (Category 15)
(1, 'Alternator', 'High output alternator', 399.99, 15, 'New', 1, 'https://example.com/alternator.jpg'),
(2, 'Starter Motor', 'Performance starter', 299.99, 15, 'New', 2, 'https://example.com/starter.jpg'),
(3, 'Battery', 'High performance battery', 199.99, 15, 'New', 3, 'https://example.com/battery.jpg'),
(4, 'ECU', 'Performance ECU, tuned', 899.99, 15, 'New', 4, 'https://example.com/ecu.jpg'),
(5, 'Ignition System', 'Complete ignition system', 499.99, 15, 'New', 5, 'https://example.com/ignition.jpg'),

-- Interior Parts (Category 16)
(6, 'Racing Seats', 'Pair of racing seats', 799.99, 16, 'New', 6, 'https://example.com/seats.jpg'),
(7, 'Steering Wheel', 'Performance steering wheel', 299.99, 16, 'New', 7, 'https://example.com/steering.jpg'),
(8, 'Gauges Set', 'Performance gauges, set of 3', 399.99, 16, 'New', 8, 'https://example.com/gauges.jpg'),
(9, 'Shift Knob', 'Custom shift knob', 49.99, 16, 'New', 9, 'https://example.com/shiftknob.jpg'),
(10, 'Floor Mats', 'Custom fit floor mats', 89.99, 16, 'New', 10, 'https://example.com/mats.jpg'),

-- Exterior Parts (Category 17)
(11, 'Body Kit', 'Complete body kit', 1299.99, 17, 'New', 11, 'https://example.com/bodykit.jpg'),
(12, 'Hood', 'Carbon fiber hood', 699.99, 17, 'New', 12, 'https://example.com/hood.jpg'),
(13, 'Bumper', 'Front bumper, new', 399.99, 17, 'New', 13, 'https://example.com/bumper.jpg'),
(14, 'Side Skirts', 'Pair of side skirts', 299.99, 17, 'New', 14, 'https://example.com/sideskirts.jpg'),
(15, 'Spoiler', 'Rear spoiler', 199.99, 17, 'New', 15, 'https://example.com/spoiler.jpg'),

-- Wheels & Tires (Category 18)
(16, 'Wheel Set', 'Set of 4 alloy wheels', 999.99, 18, 'New', 16, 'https://example.com/wheels.jpg'),
(17, 'Tire Set', 'Performance tires, set of 4', 799.99, 18, 'New', 17, 'https://example.com/tires.jpg'),
(18, 'Wheel Spacers', 'Set of 4 wheel spacers', 149.99, 18, 'New', 18, 'https://example.com/spacers.jpg'),
(19, 'Wheel Lugs', 'Set of 20 wheel lugs', 49.99, 18, 'New', 19, 'https://example.com/lugs.jpg'),
(20, 'Tire Pressure Sensors', 'Set of 4 sensors', 199.99, 18, 'New', 20, 'https://example.com/sensors.jpg'),

-- Performance Parts (Category 19)
(1, 'Turbo Kit', 'Complete turbo kit', 2999.99, 19, 'New', 1, 'https://example.com/turbo.jpg'),
(2, 'Supercharger', 'Roots type supercharger', 2499.99, 19, 'New', 2, 'https://example.com/supercharger.jpg'),
(3, 'Nitrous Kit', 'Wet nitrous system', 899.99, 19, 'New', 3, 'https://example.com/nitrous.jpg'),
(4, 'Headers', 'Performance headers', 499.99, 19, 'New', 4, 'https://example.com/headers.jpg'),
(5, 'Exhaust System', 'Complete exhaust system', 799.99, 19, 'New', 5, 'https://example.com/exhaust.jpg'),

-- Maintenance Parts (Category 20)
(6, 'Oil Filter Kit', 'Complete oil filter kit', 49.99, 20, 'New', 6, 'https://example.com/oilfilter.jpg'),
(7, 'Air Filter', 'Performance air filter', 39.99, 20, 'New', 7, 'https://example.com/airfilter.jpg'),
(8, 'Fuel Filter', 'High flow fuel filter', 29.99, 20, 'New', 8, 'https://example.com/fuelfilter.jpg'),
(9, 'Spark Plugs', 'Set of 8 spark plugs', 49.99, 20, 'New', 9, 'https://example.com/sparkplugs.jpg'),
(10, 'Timing Belt Kit', 'Complete timing belt kit', 199.99, 20, 'New', 10, 'https://example.com/timingbelt.jpg'),

-- Musical Instruments (Category 21)
(16, 'Fender Stratocaster', 'Electric guitar, sunburst finish', 799.99, 21, 'Like New', 16, 'https://example.com/guitar.jpg'),
(17, 'Yamaha Piano', 'Upright piano, excellent condition', 2999.99, 21, 'Used', 17, 'https://example.com/piano.jpg'),
(18, 'Roland Electronic Drum Kit', 'TD-17KV, barely used', 899.99, 21, 'Like New', 18, 'https://example.com/drums.jpg'),
(19, 'Saxophone', 'Professional alto sax, gold lacquer', 1299.99, 21, 'Used', 19, 'https://example.com/sax.jpg'),
(20, 'Violin', 'Handcrafted, 4/4 size', 599.99, 21, 'Like New', 20, 'https://example.com/violin.jpg'),

-- Art & Crafts (Category 22)
(1, 'Professional Paint Set', 'Acrylic paints, 24 colors', 89.99, 22, 'New', 1, 'https://example.com/paints.jpg'),
(2, 'Pottery Wheel', 'Electric, with tools', 299.99, 22, 'Like New', 2, 'https://example.com/pottery.jpg'),
(3, 'Sewing Machine', 'Brother, computerized', 199.99, 22, 'Used', 3, 'https://example.com/sewing.jpg'),
(4, 'Calligraphy Set', 'Complete set with ink and paper', 49.99, 22, 'New', 4, 'https://example.com/calligraphy.jpg'),
(5, 'Woodworking Tools', 'Professional set, 15 pieces', 399.99, 22, 'Like New', 5, 'https://example.com/woodworking.jpg'),

-- Jewelry (Category 23)
(6, 'Diamond Ring', '14k gold, 1 carat', 2999.99, 23, 'New', 6, 'https://example.com/ring.jpg'),
(7, 'Pearl Necklace', 'Freshwater pearls, 18 inches', 299.99, 23, 'Like New', 7, 'https://example.com/pearls.jpg'),
(8, 'Gold Bracelet', '18k gold, Italian made', 899.99, 23, 'New', 8, 'https://example.com/bracelet.jpg'),
(9, 'Sapphire Earrings', 'Natural sapphires, platinum', 1299.99, 23, 'Like New', 9, 'https://example.com/earrings.jpg'),
(10, 'Vintage Watch', 'Omega, 1960s', 2499.99, 23, 'Used', 10, 'https://example.com/vintagewatch.jpg'),

-- Collectibles (Category 24)
(11, 'Comic Book Collection', 'Marvel, 50 issues', 499.99, 24, 'Used', 11, 'https://example.com/comics.jpg'),
(12, 'Trading Cards', 'Pokemon, rare set', 299.99, 24, 'New', 12, 'https://example.com/cards.jpg'),
(13, 'Action Figures', 'Star Wars, complete set', 199.99, 24, 'Like New', 13, 'https://example.com/figures.jpg'),
(14, 'Vintage Coins', 'US collection, 1800s', 899.99, 24, 'Used', 14, 'https://example.com/coins.jpg'),
(15, 'Model Trains', 'HO scale, complete set', 599.99, 24, 'Like New', 15, 'https://example.com/trains.jpg'),

-- Office Supplies (Category 25)
(16, 'Desk Set', 'Executive style, complete', 199.99, 25, 'New', 16, 'https://example.com/desk.jpg'),
(17, 'Printer', 'HP LaserJet, wireless', 299.99, 25, 'Like New', 17, 'https://example.com/printer.jpg'),
(18, 'Filing Cabinet', '4-drawer, metal', 249.99, 25, 'New', 18, 'https://example.com/filing.jpg'),
(19, 'Office Chair', 'Ergonomic, mesh back', 199.99, 25, 'Like New', 19, 'https://example.com/chair.jpg'),
(20, 'Whiteboard', 'Magnetic, 4x6 feet', 149.99, 25, 'New', 20, 'https://example.com/whiteboard.jpg'),

-- Food & Beverages (Category 26)
(1, 'Wine Collection', '6 bottles, premium selection', 299.99, 26, 'New', 1, 'https://example.com/wine.jpg'),
(2, 'Coffee Maker', 'Espresso machine, professional', 399.99, 26, 'Like New', 2, 'https://example.com/coffee.jpg'),
(3, 'Spice Set', 'Gourmet spices, 24 varieties', 89.99, 26, 'New', 3, 'https://example.com/spices.jpg'),
(4, 'Cookware Set', 'Stainless steel, 12 pieces', 299.99, 26, 'New', 4, 'https://example.com/cookware.jpg'),
(5, 'Tea Collection', 'Premium loose leaf, 20 varieties', 79.99, 26, 'New', 5, 'https://example.com/tea.jpg'),

-- Baby & Kids (Category 27)
(6, 'Stroller', 'Lightweight, travel system', 299.99, 27, 'Like New', 6, 'https://example.com/stroller.jpg'),
(7, 'Crib', 'Convertible, modern design', 399.99, 27, 'New', 7, 'https://example.com/crib.jpg'),
(8, 'Toy Set', 'Educational toys, 20 pieces', 89.99, 27, 'New', 8, 'https://example.com/toys.jpg'),
(9, 'Baby Monitor', 'Video monitor, wireless', 149.99, 27, 'Like New', 9, 'https://example.com/monitor.jpg'),
(10, 'Children''s Books', 'Collection, 50 books', 99.99, 27, 'New', 10, 'https://example.com/books.jpg'),

-- Health & Fitness (Category 28)
(11, 'Treadmill', 'Professional grade, foldable', 999.99, 28, 'Like New', 11, 'https://example.com/treadmill.jpg'),
(12, 'Yoga Set', 'Complete set with mat and props', 79.99, 28, 'New', 12, 'https://example.com/yoga.jpg'),
(13, 'Weight Set', 'Adjustable dumbbells, 5-50 lbs', 299.99, 28, 'Like New', 13, 'https://example.com/weights.jpg'),
(14, 'Exercise Bike', 'Stationary, magnetic resistance', 399.99, 28, 'New', 14, 'https://example.com/bike.jpg'),
(15, 'Fitness Tracker', 'Smart watch, heart rate monitor', 199.99, 28, 'Like New', 15, 'https://example.com/tracker.jpg'),

-- Garden & Outdoor (Category 29)
(16, 'BBQ Grill', 'Gas grill, 4 burners', 499.99, 29, 'Like New', 16, 'https://example.com/grill.jpg'),
(17, 'Garden Furniture', 'Rattan set, 6 pieces', 699.99, 29, 'New', 17, 'https://example.com/garden.jpg'),
(18, 'Greenhouse', 'Walk-in, 6x8 feet', 899.99, 29, 'New', 18, 'https://example.com/greenhouse.jpg'),
(19, 'Lawn Mower', 'Self-propelled, electric', 299.99, 29, 'Like New', 19, 'https://example.com/mower.jpg'),
(20, 'Garden Tools', 'Professional set, 15 pieces', 149.99, 29, 'New', 20, 'https://example.com/gardentools.jpg'),

-- Tools & Hardware (Category 30)
(1, 'Power Tool Set', 'Cordless, 5 pieces', 399.99, 30, 'New', 1, 'https://example.com/tools.jpg'),
(2, 'Tool Chest', 'Professional, 41 inches', 299.99, 30, 'Like New', 2, 'https://example.com/chest.jpg'),
(3, 'Ladder', 'Extension, 24 feet', 199.99, 30, 'New', 3, 'https://example.com/ladder.jpg'),
(4, 'Workbench', 'Heavy duty, with vise', 249.99, 30, 'Like New', 4, 'https://example.com/workbench.jpg'),
(5, 'Measuring Tools', 'Professional set, 10 pieces', 89.99, 30, 'New', 5, 'https://example.com/measuring.jpg'),

-- Photography (Category 31)
(6, 'DSLR Camera', 'Canon EOS, with lens', 899.99, 31, 'Like New', 6, 'https://example.com/camera.jpg'),
(7, 'Camera Lens', '70-200mm, f/2.8', 1299.99, 31, 'New', 7, 'https://example.com/lens.jpg'),
(8, 'Tripod', 'Professional, carbon fiber', 199.99, 31, 'Like New', 8, 'https://example.com/tripod.jpg'),
(9, 'Lighting Kit', 'Studio lights, 3 pieces', 299.99, 31, 'New', 9, 'https://example.com/lights.jpg'),
(10, 'Camera Bag', 'Professional, waterproof', 149.99, 31, 'Like New', 10, 'https://example.com/bag.jpg'),

-- Computers & Accessories (Category 32)
(11, 'Gaming PC', 'RTX 3080, 32GB RAM', 1999.99, 32, 'Like New', 11, 'https://example.com/gamingpc.jpg'),
(12, 'Monitor', '4K, 32 inch', 399.99, 32, 'New', 12, 'https://example.com/monitor.jpg'),
(13, 'Keyboard', 'Mechanical, RGB', 149.99, 32, 'Like New', 13, 'https://example.com/keyboard.jpg'),
(14, 'Mouse', 'Gaming, wireless', 79.99, 32, 'New', 14, 'https://example.com/mouse.jpg'),
(15, 'External SSD', '1TB, USB 3.1', 129.99, 32, 'New', 15, 'https://example.com/ssd.jpg'),

-- Gaming (Category 33)
(16, 'PS5 Console', 'Digital edition, with games', 499.99, 33, 'Like New', 16, 'https://example.com/ps5.jpg'),
(17, 'Xbox Series X', 'With controller and games', 499.99, 33, 'New', 17, 'https://example.com/xbox.jpg'),
(18, 'Nintendo Switch', 'OLED model, with games', 349.99, 33, 'Like New', 18, 'https://example.com/switch.jpg'),
(19, 'Gaming Headset', 'Surround sound, wireless', 149.99, 33, 'New', 19, 'https://example.com/headset.jpg'),
(20, 'Gaming Chair', 'Ergonomic, with footrest', 299.99, 33, 'Like New', 20, 'https://example.com/gamingchair.jpg'),

-- Antiques (Category 34)
(1, 'Vintage Clock', 'Grandfather clock, 1800s', 1999.99, 34, 'Used', 1, 'https://example.com/clock.jpg'),
(2, 'Antique Desk', 'Mahogany, 1900s', 899.99, 34, 'Used', 2, 'https://example.com/antiquedesk.jpg'),
(3, 'Vintage Camera', 'Leica, 1950s', 1299.99, 34, 'Used', 3, 'https://example.com/vintagecamera.jpg'),
(4, 'Antique Vase', 'Chinese, 1800s', 599.99, 34, 'Used', 4, 'https://example.com/vase.jpg'),
(5, 'Vintage Radio', 'Philco, 1940s', 299.99, 34, 'Used', 5, 'https://example.com/radio.jpg'),

-- Party Supplies (Category 35)
(6, 'Party Tent', '10x20 feet, with sides', 299.99, 35, 'New', 6, 'https://example.com/tent.jpg'),
(7, 'Table Set', '6 tables, 24 chairs', 499.99, 35, 'Like New', 7, 'https://example.com/tables.jpg'),
(8, 'Decoration Kit', 'Complete party set', 89.99, 35, 'New', 8, 'https://example.com/decorations.jpg'),
(9, 'Sound System', 'Portable PA system', 399.99, 35, 'Like New', 9, 'https://example.com/sound.jpg'),
(10, 'Catering Equipment', 'Complete set, 50 pieces', 699.99, 35, 'New', 10, 'https://example.com/catering.jpg'),

-- Travel Gear (Category 36)
(11, 'Luggage Set', '3 pieces, hardshell', 299.99, 36, 'New', 11, 'https://example.com/luggage.jpg'),
(12, 'Backpack', 'Travel, 40L', 129.99, 36, 'Like New', 12, 'https://example.com/backpack.jpg'),
(13, 'Travel Pillow', 'Memory foam, compact', 29.99, 36, 'New', 13, 'https://example.com/pillow.jpg'),
(14, 'Portable Charger', '20000mAh, fast charging', 49.99, 36, 'New', 14, 'https://example.com/charger.jpg'),
(15, 'Travel Adapter', 'Universal, 150 countries', 39.99, 36, 'New', 15, 'https://example.com/adapter.jpg'),

-- Pet Supplies (Category 37)
(16, 'Dog House', 'Weatherproof, large size', 199.99, 37, 'New', 16, 'https://example.com/doghouse.jpg'),
(17, 'Cat Tree', 'Multi-level, with toys', 149.99, 37, 'Like New', 17, 'https://example.com/cattree.jpg'),
(18, 'Aquarium', '55 gallon, complete set', 299.99, 37, 'New', 18, 'https://example.com/aquarium.jpg'),
(19, 'Pet Carrier', 'Airline approved, large', 79.99, 37, 'New', 19, 'https://example.com/carrier.jpg'),
(20, 'Pet Bed', 'Memory foam, washable', 89.99, 37, 'Like New', 20, 'https://example.com/petbed.jpg'),

-- Home Improvement (Category 38)
(1, 'Paint Set', 'Interior, 5 gallons', 149.99, 38, 'New', 1, 'https://example.com/paint.jpg'),
(2, 'Flooring', 'Hardwood, 200 sq ft', 899.99, 38, 'New', 2, 'https://example.com/flooring.jpg'),
(3, 'Light Fixtures', 'Set of 6, modern design', 299.99, 38, 'New', 3, 'https://example.com/lights.jpg'),
(4, 'Bathroom Vanity', 'Double sink, marble top', 599.99, 38, 'New', 4, 'https://example.com/vanity.jpg'),
(5, 'Kitchen Faucet', 'Pull-down, brushed nickel', 199.99, 38, 'New', 5, 'https://example.com/faucet.jpg'),

-- Industrial & Scientific (Category 39)
(6, 'Microscope', 'Professional, 1000x', 599.99, 39, 'Like New', 6, 'https://example.com/microscope.jpg'),
(7, 'Lab Equipment', 'Complete set, 20 pieces', 999.99, 39, 'New', 7, 'https://example.com/lab.jpg'),
(8, 'Measuring Tools', 'Precision set, 10 pieces', 299.99, 39, 'New', 8, 'https://example.com/measuring.jpg'),
(9, 'Safety Equipment', 'Complete set, 15 pieces', 199.99, 39, 'New', 9, 'https://example.com/safety.jpg'),
(10, 'Industrial Scale', 'Digital, 1000lb capacity', 399.99, 39, 'Like New', 10, 'https://example.com/scale.jpg');

-- Insert orders for sample transactions
INSERT INTO orders (id, buyer_id, seller_id, product_id, status) VALUES
    -- Electronics orders
    (1, 3, 1, 1, 'completed'),  -- iPhone purchase
    (2, 6, 5, 2, 'completed'),  -- Laptop purchase
    (3, 11, 7, 4, 'completed'), -- Camera purchase
    
    -- Fashion orders
    (4, 15, 2, 6, 'completed'),  -- Designer clothes
    (5, 1, 4, 9, 'completed'),   -- Accessories
    
    -- Vehicle Parts orders
    (6, 5, 8, 16, 'completed'),  -- Engine parts
    (7, 11, 10, 19, 'completed'), -- Brake system
    
    -- Engine Parts orders
    (8, 15, 12, 21, 'completed'), -- Performance parts
    (9, 1, 14, 24, 'completed'),  -- Transmission parts
    
    -- Musical Instruments orders
    (10, 5, 16, 41, 'completed'), -- Guitar
    (11, 11, 18, 44, 'completed'); -- Piano

-- Insert reviews for completed orders
INSERT INTO reviews (reviewer_id, reviewed_id, order_id, rating, comment) VALUES
    -- Electronics reviews
    (3, 1, 1, 5, 'Great seller! iPhone was in perfect condition as described.'),
    (6, 5, 2, 4, 'Laptop works great, fast shipping. Minor scratch not mentioned but otherwise perfect.'),
    (11, 7, 3, 5, 'Camera was exactly as described, excellent communication!'),
    
    -- Fashion reviews
    (15, 2, 4, 5, 'Beautiful designer clothes, exactly as pictured. Fast shipping!'),
    (1, 4, 5, 4, 'Nice accessories, good quality. Shipping was a bit slow.'),
    
    -- Vehicle Parts reviews
    (5, 8, 6, 5, 'Perfect engine parts, great technical knowledge and support!'),
    (11, 10, 7, 5, 'Brake system was in excellent condition, professional installation advice provided.'),
    
    -- Engine Parts reviews
    (15, 12, 8, 4, 'Performance parts work great, slight delay in shipping but worth the wait.'),
    (1, 14, 9, 5, 'Transmission parts were perfect, seller provided detailed installation instructions.'),
    
    -- Musical Instruments reviews
    (5, 16, 10, 5, 'Guitar is beautiful and sounds amazing! Exactly as described.'),
    (11, 18, 11, 5, 'Piano was in pristine condition, seller was very helpful with delivery arrangements.');

-- Insert default notifications
INSERT INTO notifications (user_id, type, title, message, related_id, related_type, is_read) VALUES
-- Welcome Notifications
(1, 'welcome', 'Welcome to AutoParts Marketplace!', 'Welcome to AutoParts Marketplace! Start exploring parts and connecting with sellers.', NULL, NULL, FALSE),
(2, 'welcome', 'Welcome to AutoParts Marketplace!', 'Welcome to AutoParts Marketplace! Start exploring parts and connecting with sellers.', NULL, NULL, FALSE),
(3, 'welcome', 'Welcome to AutoParts Marketplace!', 'Welcome to AutoParts Marketplace! Start exploring parts and connecting with sellers.', NULL, NULL, FALSE),
(4, 'welcome', 'Welcome to AutoParts Marketplace!', 'Welcome to AutoParts Marketplace! Start exploring parts and connecting with sellers.', NULL, NULL, FALSE),
(5, 'welcome', 'Welcome to AutoParts Marketplace!', 'Welcome to AutoParts Marketplace! Start exploring parts and connecting with sellers.', NULL, NULL, FALSE),

-- Order Notifications
(1, 'order', 'New Order Received', 'You have received a new order for iPhone 13 Pro', 1, 'product', FALSE),
(2, 'order', 'Order Shipped', 'Your order #123 has been shipped', 2, 'order', FALSE),
(3, 'order', 'Order Delivered', 'Your order #124 has been delivered', 3, 'order', FALSE),
(4, 'order', 'Order Cancelled', 'Order #125 has been cancelled', 4, 'order', FALSE),
(5, 'order', 'Order Refunded', 'Your order #126 has been refunded', 5, 'order', FALSE),

-- Message Notifications
(6, 'message', 'New Message', 'You have a new message from John Doe', 6, 'user', FALSE),
(7, 'message', 'New Message', 'You have a new message from Jane Smith', 7, 'user', FALSE),
(8, 'message', 'New Message', 'You have a new message from Mike Wilson', 8, 'user', FALSE),
(9, 'message', 'New Message', 'You have a new message from Sarah Jones', 9, 'user', FALSE),
(10, 'message', 'New Message', 'You have a new message from Alex Chen', 10, 'user', FALSE),

-- Review Notifications
(11, 'review', 'New Review', 'You received a 5-star review for your listing', 11, 'product', FALSE),
(12, 'review', 'New Review', 'You received a 4-star review for your listing', 12, 'product', FALSE),
(13, 'review', 'Review Response', 'Someone responded to your review', 13, 'review', FALSE),
(14, 'review', 'Review Updated', 'A review for your listing was updated', 14, 'review', FALSE),
(15, 'review', 'Review Deleted', 'A review for your listing was removed', 15, 'review', FALSE),

-- Product Notifications
(16, 'product', 'Price Drop', 'A product you saved has dropped in price', 16, 'product', FALSE),
(17, 'product', 'Back in Stock', 'A product you were interested in is back in stock', 17, 'product', FALSE),
(18, 'product', 'Similar Item', 'We found similar items you might like', 18, 'product', FALSE),
(19, 'product', 'Listing Expired', 'Your listing will expire in 3 days', 19, 'product', FALSE),
(20, 'product', 'Listing Featured', 'Your listing has been featured', 20, 'product', FALSE),

-- System Notifications
(1, 'system', 'Account Verified', 'Your account has been verified', NULL, NULL, FALSE),
(2, 'system', 'Password Changed', 'Your password was recently changed', NULL, NULL, FALSE),
(3, 'system', 'Email Updated', 'Your email address was updated', NULL, NULL, FALSE),
(4, 'system', 'Phone Verified', 'Your phone number has been verified', NULL, NULL, FALSE),
(5, 'system', 'Profile Updated', 'Your profile was recently updated', NULL, NULL, FALSE),

-- Security Notifications
(6, 'security', 'New Login', 'New login detected from a new device', NULL, NULL, FALSE),
(7, 'security', 'Suspicious Activity', 'Unusual activity detected on your account', NULL, NULL, FALSE),
(8, 'security', 'Password Reset', 'Your password was reset', NULL, NULL, FALSE),
(9, 'security', 'Two-Factor Enabled', 'Two-factor authentication has been enabled', NULL, NULL, FALSE),
(10, 'security', 'Account Locked', 'Your account has been temporarily locked', NULL, NULL, FALSE),

-- Promotion Notifications
(11, 'promotion', 'Special Offer', 'Get 20% off your next purchase', NULL, NULL, FALSE),
(12, 'promotion', 'Flash Sale', 'Flash sale on selected items', NULL, NULL, FALSE),
(13, 'promotion', 'Referral Bonus', 'You earned a $10 bonus for your referral', NULL, NULL, FALSE),
(14, 'promotion', 'Loyalty Points', 'You earned 100 loyalty points', NULL, NULL, FALSE),
(15, 'promotion', 'Seasonal Sale', 'Check out our seasonal sale', NULL, NULL, FALSE),

-- Vehicle Parts Specific Notifications
(16, 'parts', 'Part Match', 'We found a matching part for your vehicle', 16, 'product', FALSE),
(17, 'parts', 'Compatibility Alert', 'New compatible parts available for your vehicle', 17, 'product', FALSE),
(18, 'parts', 'Price Alert', 'Price dropped on parts you were viewing', 18, 'product', FALSE),
(19, 'parts', 'Stock Alert', 'Low stock alert for parts in your wishlist', 19, 'product', FALSE),
(20, 'parts', 'New Arrival', 'New parts arrived for your vehicle model', 20, 'product', FALSE),

-- Social Notifications
(1, 'social', 'New Follower', 'You have a new follower', 1, 'user', FALSE),
(2, 'social', 'Profile View', 'Someone viewed your profile', 2, 'user', FALSE),
(3, 'social', 'Connection Request', 'New connection request received', 3, 'user', FALSE),
(4, 'social', 'Share', 'Someone shared your listing', 4, 'product', FALSE),
(5, 'social', 'Mention', 'You were mentioned in a comment', 5, 'comment', FALSE),

-- Maintenance Notifications
(6, 'maintenance', 'Service Reminder', 'Time for your vehicle maintenance', NULL, NULL, FALSE),
(7, 'maintenance', 'Part Replacement', 'Recommended part replacement', 7, 'product', FALSE),
(8, 'maintenance', 'Service History', 'Your service history is available', NULL, NULL, FALSE),
(9, 'maintenance', 'Warranty Alert', 'Your warranty is expiring soon', NULL, NULL, FALSE),
(10, 'maintenance', 'Recall Notice', 'Important recall notice for your vehicle', NULL, NULL, FALSE),

-- Location Based Notifications
(11, 'location', 'Nearby Seller', 'New seller in your area', 11, 'user', FALSE),
(12, 'location', 'Local Deal', 'Special deals in your area', 12, 'product', FALSE),
(13, 'location', 'Meetup Available', 'Local pickup available for your order', 13, 'order', FALSE),
(14, 'location', 'Service Nearby', 'New service provider in your area', 14, 'service', FALSE),
(15, 'location', 'Event Nearby', 'Auto parts swap meet in your area', NULL, NULL, FALSE),

-- Final Batch of Notifications
(16, 'system', 'App Update', 'New features available in the latest update', NULL, NULL, FALSE),
(17, 'system', 'Feedback Request', 'How was your recent purchase?', 17, 'order', FALSE),
(18, 'system', 'Document Expiry', 'Your seller documents are expiring soon', NULL, NULL, FALSE),
(19, 'system', 'Payment Method', 'New payment method added', NULL, NULL, FALSE),
(20, 'system', 'Account Summary', 'Your monthly account summary is ready', NULL, NULL, FALSE);

-- Insert default settings
INSERT INTO settings (user_id, notification_settings, saved_items, order_history, review_history) VALUES
-- User 1 (John Doe - Tech Enthusiast)
(1, '{"email": true, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}', 
'[1, 2, 3, 4, 5]', 
'[{"order_id": 1, "date": "2024-03-01", "status": "completed"}, {"order_id": 2, "date": "2024-03-15", "status": "pending"}]',
'[{"review_id": 1, "rating": 5, "date": "2024-03-05"}, {"review_id": 2, "rating": 4, "date": "2024-03-20"}]'),

-- User 2 (Jane Smith - Fashion Designer)
(2, '{"email": true, "push": false, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[6, 7, 8, 9, 10]',
'[{"order_id": 3, "date": "2024-03-02", "status": "completed"}, {"order_id": 4, "date": "2024-03-16", "status": "shipped"}]',
'[{"review_id": 3, "rating": 5, "date": "2024-03-06"}, {"review_id": 4, "rating": 5, "date": "2024-03-21"}]'),

-- User 3 (Mike Wilson - Sports Equipment Seller)
(3, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": false, "new_messages": true, "promotions": false, "security_alerts": true}',
'[11, 12, 13, 14, 15]',
'[{"order_id": 5, "date": "2024-03-03", "status": "completed"}, {"order_id": 6, "date": "2024-03-17", "status": "delivered"}]',
'[{"review_id": 5, "rating": 4, "date": "2024-03-07"}, {"review_id": 6, "rating": 5, "date": "2024-03-22"}]'),

-- User 4 (Sarah Jones - Art Collector)
(4, '{"email": true, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[16, 17, 18, 19, 20]',
'[{"order_id": 7, "date": "2024-03-04", "status": "completed"}, {"order_id": 8, "date": "2024-03-18", "status": "processing"}]',
'[{"review_id": 7, "rating": 5, "date": "2024-03-08"}, {"review_id": 8, "rating": 4, "date": "2024-03-23"}]'),

-- User 5 (Alex Chen - Car Enthusiast)
(5, '{"email": true, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[21, 22, 23, 24, 25]',
'[{"order_id": 9, "date": "2024-03-05", "status": "completed"}, {"order_id": 10, "date": "2024-03-19", "status": "shipped"}]',
'[{"review_id": 9, "rating": 5, "date": "2024-03-09"}, {"review_id": 10, "rating": 5, "date": "2024-03-24"}]'),

-- User 6 (Emma Rodriguez - Vintage Car Restorer)
(6, '{"email": false, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[26, 27, 28, 29, 30]',
'[{"order_id": 11, "date": "2024-03-06", "status": "completed"}, {"order_id": 12, "date": "2024-03-20", "status": "pending"}]',
'[{"review_id": 11, "rating": 5, "date": "2024-03-10"}, {"review_id": 12, "rating": 4, "date": "2024-03-25"}]'),

-- User 7 (David Kim - Auto Parts Specialist)
(7, '{"email": true, "push": false, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[31, 32, 33, 34, 35]',
'[{"order_id": 13, "date": "2024-03-07", "status": "completed"}, {"order_id": 14, "date": "2024-03-21", "status": "shipped"}]',
'[{"review_id": 13, "rating": 5, "date": "2024-03-11"}, {"review_id": 14, "rating": 5, "date": "2024-03-26"}]'),

-- User 8 (Lisa Patel - Classic Car Collector)
(8, '{"email": true, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[36, 37, 38, 39, 40]',
'[{"order_id": 15, "date": "2024-03-08", "status": "completed"}, {"order_id": 16, "date": "2024-03-22", "status": "delivered"}]',
'[{"review_id": 15, "rating": 4, "date": "2024-03-12"}, {"review_id": 16, "rating": 5, "date": "2024-03-27"}]'),

-- User 9 (James Wilson - Performance Parts Dealer)
(9, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[41, 42, 43, 44, 45]',
'[{"order_id": 17, "date": "2024-03-09", "status": "completed"}, {"order_id": 18, "date": "2024-03-23", "status": "processing"}]',
'[{"review_id": 17, "rating": 5, "date": "2024-03-13"}, {"review_id": 18, "rating": 4, "date": "2024-03-28"}]'),

-- User 10 (Maria Garcia - Auto Repair Shop Owner)
(10, '{"email": true, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[46, 47, 48, 49, 50]',
'[{"order_id": 19, "date": "2024-03-10", "status": "completed"}, {"order_id": 20, "date": "2024-03-24", "status": "shipped"}]',
'[{"review_id": 19, "rating": 5, "date": "2024-03-14"}, {"review_id": 20, "rating": 5, "date": "2024-03-29"}]'),

-- User 11 (Robert Taylor - Motorcycle Parts Specialist)
(11, '{"email": true, "push": false, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[51, 52, 53, 54, 55]',
'[{"order_id": 21, "date": "2024-03-11", "status": "completed"}, {"order_id": 22, "date": "2024-03-25", "status": "pending"}]',
'[{"review_id": 21, "rating": 5, "date": "2024-03-15"}, {"review_id": 22, "rating": 4, "date": "2024-03-30"}]'),

-- User 12 (Sophie Martin - Car Audio System Expert)
(12, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[56, 57, 58, 59, 60]',
'[{"order_id": 23, "date": "2024-03-12", "status": "completed"}, {"order_id": 24, "date": "2024-03-26", "status": "shipped"}]',
'[{"review_id": 23, "rating": 5, "date": "2024-03-16"}, {"review_id": 24, "rating": 5, "date": "2024-03-31"}]'),

-- User 13 (Michael Brown - Truck Parts Dealer)
(13, '{"email": true, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[61, 62, 63, 64, 65]',
'[{"order_id": 25, "date": "2024-03-13", "status": "completed"}, {"order_id": 26, "date": "2024-03-27", "status": "delivered"}]',
'[{"review_id": 25, "rating": 4, "date": "2024-03-17"}, {"review_id": 26, "rating": 5, "date": "2024-04-01"}]'),

-- User 14 (Anna Kowalski - Electric Vehicle Specialist)
(14, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[66, 67, 68, 69, 70]',
'[{"order_id": 27, "date": "2024-03-14", "status": "completed"}, {"order_id": 28, "date": "2024-03-28", "status": "processing"}]',
'[{"review_id": 27, "rating": 5, "date": "2024-03-18"}, {"review_id": 28, "rating": 4, "date": "2024-04-02"}]'),

-- User 15 (Thomas Nguyen - Import Car Parts Dealer)
(15, '{"email": true, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[71, 72, 73, 74, 75]',
'[{"order_id": 29, "date": "2024-03-15", "status": "completed"}, {"order_id": 30, "date": "2024-03-29", "status": "shipped"}]',
'[{"review_id": 29, "rating": 5, "date": "2024-03-19"}, {"review_id": 30, "rating": 5, "date": "2024-04-03"}]'),

-- User 16 (Olivia Lee - Luxury Car Parts Specialist)
(16, '{"email": true, "push": false, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[76, 77, 78, 79, 80]',
'[{"order_id": 31, "date": "2024-03-16", "status": "completed"}, {"order_id": 32, "date": "2024-03-30", "status": "pending"}]',
'[{"review_id": 31, "rating": 5, "date": "2024-03-20"}, {"review_id": 32, "rating": 4, "date": "2024-04-04"}]'),

-- User 17 (William Clark - Off-road Parts Dealer)
(17, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[81, 82, 83, 84, 85]',
'[{"order_id": 33, "date": "2024-03-17", "status": "completed"}, {"order_id": 34, "date": "2024-03-31", "status": "shipped"}]',
'[{"review_id": 33, "rating": 5, "date": "2024-03-21"}, {"review_id": 34, "rating": 5, "date": "2024-04-05"}]'),

-- User 18 (Isabella Moore - Vintage Motorcycle Collector)
(18, '{"email": true, "push": true, "sms": false, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[86, 87, 88, 89, 90]',
'[{"order_id": 35, "date": "2024-03-18", "status": "completed"}, {"order_id": 36, "date": "2024-04-01", "status": "delivered"}]',
'[{"review_id": 35, "rating": 4, "date": "2024-03-22"}, {"review_id": 36, "rating": 5, "date": "2024-04-06"}]'),

-- User 19 (Daniel White - Performance Tuning Expert)
(19, '{"email": false, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": false, "security_alerts": true}',
'[91, 92, 93, 94, 95]',
'[{"order_id": 37, "date": "2024-03-19", "status": "completed"}, {"order_id": 38, "date": "2024-04-02", "status": "processing"}]',
'[{"review_id": 37, "rating": 5, "date": "2024-03-23"}, {"review_id": 38, "rating": 4, "date": "2024-04-07"}]'),

-- User 20 (Emily Davis - Auto Body Parts Specialist)
(20, '{"email": true, "push": true, "sms": true, "order_updates": true, "price_alerts": true, "new_messages": true, "promotions": true, "security_alerts": true}',
'[96, 97, 98, 99, 100]',
'[{"order_id": 39, "date": "2024-03-20", "status": "completed"}, {"order_id": 40, "date": "2024-04-03", "status": "shipped"}]',
'[{"review_id": 39, "rating": 5, "date": "2024-03-24"}, {"review_id": 40, "rating": 5, "date": "2024-04-08"}]');

-- Insert default user interactions
INSERT INTO user_interactions (user_id, product_id, interaction_type) VALUES
    -- Electronics interactions
    (1, 1, 'view'),
    (1, 1, 'like'),
    (2, 1, 'view'),
    (3, 1, 'purchase'),
    (4, 1, 'message'),
    (5, 2, 'view'),
    (5, 2, 'like'),
    (6, 2, 'purchase'),
    (7, 3, 'view'),
    (8, 3, 'like'),
    (9, 3, 'message'),
    (10, 4, 'view'),
    (11, 4, 'purchase'),
    (12, 5, 'view'),
    (13, 5, 'like'),
    
    -- Fashion interactions
    (14, 6, 'view'),
    (15, 6, 'purchase'),
    (16, 7, 'view'),
    (17, 7, 'like'),
    (18, 8, 'view'),
    (19, 8, 'message'),
    (20, 9, 'view'),
    (1, 9, 'purchase'),
    (2, 10, 'view'),
    (3, 10, 'like'),
    
    -- Vehicle Parts interactions
    (4, 16, 'view'),
    (5, 16, 'purchase'),
    (6, 17, 'view'),
    (7, 17, 'like'),
    (8, 18, 'view'),
    (9, 18, 'message'),
    (10, 19, 'view'),
    (11, 19, 'purchase'),
    (12, 20, 'view'),
    (13, 20, 'like'),
    
    -- Engine Parts interactions
    (14, 21, 'view'),
    (15, 21, 'purchase'),
    (16, 22, 'view'),
    (17, 22, 'like'),
    (18, 23, 'view'),
    (19, 23, 'message'),
    (20, 24, 'view'),
    (1, 24, 'purchase'),
    (2, 25, 'view'),
    (3, 25, 'like'),
    
    -- Musical Instruments interactions
    (4, 41, 'view'),
    (5, 41, 'purchase'),
    (6, 42, 'view'),
    (7, 42, 'like'),
    (8, 43, 'view'),
    (9, 43, 'message'),
    (10, 44, 'view'),
    (11, 44, 'purchase'),
    (12, 45, 'view'),
    (13, 45, 'like');

-- Insert default product popularity
INSERT INTO product_popularity (product_id, view_count, favorite_count, message_count, purchase_count) VALUES
    -- Electronics popularity
    (1, 150, 25, 8, 3),
    (2, 200, 35, 12, 4),
    (3, 180, 30, 10, 2),
    (4, 120, 20, 6, 1),
    (5, 160, 28, 9, 3),
    
    -- Fashion popularity
    (6, 250, 40, 15, 5),
    (7, 180, 30, 10, 2),
    (8, 220, 35, 12, 4),
    (9, 300, 45, 18, 6),
    (10, 150, 25, 8, 2),
    
    -- Vehicle Parts popularity
    (16, 280, 42, 16, 5),
    (17, 220, 35, 12, 3),
    (18, 190, 32, 11, 2),
    (19, 250, 38, 14, 4),
    (20, 170, 28, 9, 2),
    
    -- Engine Parts popularity
    (21, 260, 40, 15, 4),
    (22, 210, 33, 12, 3),
    (23, 180, 30, 10, 2),
    (24, 240, 36, 13, 4),
    (25, 160, 26, 8, 2),
    
    -- Musical Instruments popularity
    (41, 290, 44, 17, 5),
    (42, 230, 36, 13, 3),
    (43, 200, 32, 11, 2),
    (44, 270, 40, 15, 4),
    (45, 180, 29, 9, 2);

-- Insert default user preferences
INSERT INTO user_preferences (user_id, preferred_categories, preferred_price_range, preferred_locations) VALUES
    -- Tech enthusiast preferences
    (1, '["Electronics", "Computers & Accessories", "Gaming"]', '{"min": 500, "max": 2000}', '["New York, NY", "Los Angeles, CA", "San Francisco, CA"]'),
    (2, '["Fashion", "Jewelry", "Beauty & Health"]', '{"min": 100, "max": 1000}', '["Los Angeles, CA", "Miami, FL", "Chicago, IL"]'),
    (3, '["Sports", "Health & Fitness", "Outdoor Gear"]', '{"min": 50, "max": 500}', '["Chicago, IL", "Denver, CO", "Seattle, WA"]'),
    (4, '["Art & Crafts", "Collectibles", "Antiques"]', '{"min": 200, "max": 2000}', '["San Francisco, CA", "New York, NY", "Boston, MA"]'),
    (5, '["Vehicle Parts", "Engine Parts", "Performance Parts"]', '{"min": 100, "max": 3000}', '["Detroit, MI", "Los Angeles, CA", "Houston, TX"]'),
    
    -- Car enthusiast preferences
    (6, '["Vehicle Parts", "Exterior Parts", "Wheels & Tires"]', '{"min": 200, "max": 2000}', '["Los Angeles, CA", "Miami, FL", "Las Vegas, NV"]'),
    (7, '["Vehicle Parts", "Engine Parts", "Transmission Parts"]', '{"min": 500, "max": 5000}', '["Detroit, MI", "Chicago, IL", "Dallas, TX"]'),
    (8, '["Vehicle Parts", "Interior Parts", "Electrical Parts"]', '{"min": 100, "max": 1000}', '["New York, NY", "Boston, MA", "Philadelphia, PA"]'),
    (9, '["Vehicle Parts", "Performance Parts", "Maintenance Parts"]', '{"min": 300, "max": 3000}', '["Houston, TX", "Phoenix, AZ", "San Diego, CA"]'),
    (10, '["Vehicle Parts", "Brake Parts", "Suspension Parts"]', '{"min": 200, "max": 2000}', '["Seattle, WA", "Portland, OR", "Denver, CO"]'),
    
    -- General user preferences
    (11, '["Electronics", "Fashion", "Home & Garden"]', '{"min": 50, "max": 500}', '["Chicago, IL", "Minneapolis, MN", "Indianapolis, IN"]'),
    (12, '["Books", "Office Supplies", "Art & Crafts"]', '{"min": 20, "max": 200}', '["Boston, MA", "Providence, RI", "Hartford, CT"]'),
    (13, '["Sports", "Fitness", "Outdoor Gear"]', '{"min": 100, "max": 1000}', '["Denver, CO", "Salt Lake City, UT", "Portland, OR"]'),
    (14, '["Electronics", "Gaming", "Computers"]', '{"min": 200, "max": 2000}', '["Seattle, WA", "San Francisco, CA", "Portland, OR"]'),
    (15, '["Fashion", "Beauty", "Accessories"]', '{"min": 50, "max": 500}', '["Miami, FL", "Orlando, FL", "Tampa, FL"]');

-- Insert default user search history
INSERT INTO search_history (user_id, query, category, filters, result_count) VALUES
    -- Tech enthusiast searches
    (1, 'iPhone 13 Pro', 'Electronics', '{"min_price": 800, "max_price": 1000, "condition": "Like New", "location": "New York, NY"}', 5),
    (1, 'MacBook Pro', 'Electronics', '{"min_price": 1000, "max_price": 2000, "condition": "New", "location": "New York, NY"}', 8),
    (1, 'Gaming PC', 'Computers & Accessories', '{"min_price": 1500, "max_price": 3000, "condition": "New", "location": "New York, NY"}', 12),
    
    -- Car enthusiast searches
    (5, 'Turbo Kit', 'Performance Parts', '{"min_price": 2000, "max_price": 4000, "condition": "New", "location": "Detroit, MI"}', 6),
    (5, 'Engine Block', 'Engine Parts', '{"min_price": 1000, "max_price": 3000, "condition": "Used", "location": "Detroit, MI"}', 4),
    (5, 'Performance Exhaust', 'Performance Parts', '{"min_price": 500, "max_price": 1500, "condition": "New", "location": "Detroit, MI"}', 9),
    
    -- Fashion enthusiast searches
    (2, 'Designer Watch', 'Fashion', '{"min_price": 500, "max_price": 1000, "condition": "New", "location": "Los Angeles, CA"}', 7),
    (2, 'Leather Jacket', 'Fashion', '{"min_price": 200, "max_price": 500, "condition": "Like New", "location": "Los Angeles, CA"}', 10),
    (2, 'Designer Bag', 'Fashion', '{"min_price": 1000, "max_price": 2000, "condition": "New", "location": "Los Angeles, CA"}', 5),
    
    -- Sports enthusiast searches
    (3, 'Treadmill', 'Health & Fitness', '{"min_price": 800, "max_price": 1500, "condition": "Like New", "location": "Chicago, IL"}', 4),
    (3, 'Yoga Set', 'Health & Fitness', '{"min_price": 50, "max_price": 200, "condition": "New", "location": "Chicago, IL"}', 15),
    (3, 'Weight Set', 'Health & Fitness', '{"min_price": 200, "max_price": 500, "condition": "New", "location": "Chicago, IL"}', 8),
    
    -- Art enthusiast searches
    (4, 'Professional Paint Set', 'Art & Crafts', '{"min_price": 50, "max_price": 200, "condition": "New", "location": "San Francisco, CA"}', 12),
    (4, 'Pottery Wheel', 'Art & Crafts', '{"min_price": 200, "max_price": 500, "condition": "Like New", "location": "San Francisco, CA"}', 6),
    (4, 'Sewing Machine', 'Art & Crafts', '{"min_price": 150, "max_price": 400, "condition": "Used", "location": "San Francisco, CA"}', 9);

-- Insert default reports
INSERT INTO reports (user_id, reported_user_id, report_type, validation, ban) VALUES
    (1, 2, 'spam', FALSE, FALSE),
    (2, 3, 'inappropriate content', TRUE, TRUE),
    (3, 4, 'fraud', FALSE, FALSE),
    (4, 1, 'spam', TRUE, FALSE),
    (5, 6, 'counterfeit items', TRUE, TRUE),
    (6, 7, 'harassment', TRUE, TRUE),
    (7, 8, 'fake listings', FALSE, FALSE),
    (8, 9, 'spam', TRUE, FALSE),
    (9, 10, 'inappropriate content', FALSE, FALSE),
    (10, 11, 'fraud', TRUE, TRUE);

-- Insert default bans
INSERT INTO bans (user_id, reason) VALUES
    (2, 'Spamming and inappropriate content'),
    (3, 'Fraudulent activity and spamming'),
    (5, 'Selling counterfeit items'),
    (6, 'Harassment of other users'),
    (10, 'Fraudulent transactions');

-- Insert default user suspensions
INSERT INTO user_suspensions (user_id, suspension_type, reason) VALUES
    (2, 'spam', 'Spamming and inappropriate content'),
    (3, 'fraud', 'Fraudulent activity and spamming'),
    (5, 'counterfeit', 'Selling counterfeit items'),
    (6, 'harassment', 'Harassment of other users'),
    (10, 'fraud', 'Fraudulent transactions');

-- Add user location preferences
INSERT INTO user_location_preferences (user_id, city_id, is_primary) VALUES
-- John Doe's preferences (New York primary, multiple secondary locations)
(1, 1, true),  -- New York (primary)
(1, 2, false), -- Los Angeles
(1, 3, false), -- Chicago
(1, 4, false), -- Houston
(1, 5, false), -- San Francisco

-- Jane Smith's preferences (Los Angeles primary, multiple secondary locations)
(2, 2, true),  -- Los Angeles (primary)
(2, 1, false), -- New York
(2, 6, false), -- Miami
(2, 7, false), -- Seattle
(2, 8, false), -- Atlanta

-- Mike Wilson's preferences (Chicago primary, multiple secondary locations)
(3, 3, true),  -- Chicago (primary)
(3, 4, false), -- Houston
(3, 9, false), -- Portland
(3, 10, false), -- Phoenix
(3, 11, false), -- Denver

-- Sarah Jones's preferences (Houston primary, multiple secondary locations)
(4, 4, true),  -- Houston (primary)
(4, 3, false), -- Chicago
(4, 12, false), -- Boston
(4, 13, false), -- Dallas
(4, 14, false), -- Detroit

-- Alex Chen's preferences (San Francisco primary, multiple secondary locations)
(5, 5, true),  -- San Francisco (primary)
(5, 15, false), -- San Diego
(5, 16, false), -- Las Vegas
(5, 17, false), -- Minneapolis
(5, 18, false), -- Cleveland

-- Emma Rodriguez's preferences (Miami primary, multiple secondary locations)
(6, 6, true),  -- Miami (primary)
(6, 19, false), -- Tampa
(6, 20, false), -- Orlando
(6, 7, false),  -- Seattle
(6, 8, false),  -- Atlanta

-- David Kim's preferences (Seattle primary, multiple secondary locations)
(7, 7, true),  -- Seattle (primary)
(7, 9, false),  -- Portland
(7, 10, false), -- Phoenix
(7, 11, false), -- Denver
(7, 12, false), -- Boston

-- Lisa Patel's preferences (Atlanta primary, multiple secondary locations)
(8, 8, true),  -- Atlanta (primary)
(8, 13, false), -- Dallas
(8, 14, false), -- Detroit
(8, 15, false), -- San Diego
(8, 16, false), -- Las Vegas

-- James Wilson's preferences (Portland primary, multiple secondary locations)
(9, 9, true),  -- Portland (primary)
(9, 10, false), -- Phoenix
(9, 11, false), -- Denver
(9, 12, false), -- Boston
(9, 13, false), -- Dallas

-- Maria Garcia's preferences (Phoenix primary, multiple secondary locations)
(10, 10, true), -- Phoenix (primary)
(10, 14, false), -- Detroit
(10, 15, false), -- San Diego
(10, 16, false), -- Las Vegas
(10, 17, false), -- Minneapolis

-- Robert Taylor's preferences (Denver primary, multiple secondary locations)
(11, 11, true), -- Denver (primary)
(11, 17, false), -- Minneapolis
(11, 18, false), -- Cleveland
(11, 19, false), -- Tampa
(11, 20, false), -- Orlando

-- Sophie Martin's preferences (Boston primary, multiple secondary locations)
(12, 12, true), -- Boston (primary)
(12, 18, false), -- Cleveland
(12, 19, false), -- Tampa
(12, 20, false), -- Orlando
(12, 1, false),  -- New York

-- Michael Brown's preferences (Dallas primary, multiple secondary locations)
(13, 13, true), -- Dallas (primary)
(13, 2, false),  -- Los Angeles
(13, 3, false),  -- Chicago
(13, 4, false),  -- Houston
(13, 5, false),  -- San Francisco

-- Anna Kowalski's preferences (Detroit primary, multiple secondary locations)
(14, 14, true), -- Detroit (primary)
(14, 6, false),  -- Miami
(14, 7, false),  -- Seattle
(14, 8, false),  -- Atlanta
(14, 9, false),  -- Portland

-- Thomas Nguyen's preferences (San Diego primary, multiple secondary locations)
(15, 15, true), -- San Diego (primary)
(15, 10, false), -- Phoenix
(15, 11, false), -- Denver
(15, 12, false), -- Boston
(15, 13, false), -- Dallas

-- Olivia Lee's preferences (Las Vegas primary, multiple secondary locations)
(16, 16, true), -- Las Vegas (primary)
(16, 14, false), -- Detroit
(16, 15, false), -- San Diego
(16, 17, false), -- Minneapolis

-- William Clark's preferences (Minneapolis primary, multiple secondary locations)
(17, 17, true), -- Minneapolis (primary)
(17, 18, false), -- Cleveland
(17, 19, false), -- Tampa
(17, 20, false), -- Orlando
(17, 1, false),  -- New York

-- Isabella Moore's preferences (Cleveland primary, multiple secondary locations)
(18, 18, true), -- Cleveland (primary)
(18, 2, false),  -- Los Angeles
(18, 3, false),  -- Chicago
(18, 4, false),  -- Houston
(18, 5, false),  -- San Francisco

-- Daniel White's preferences (Tampa primary, multiple secondary locations)
(19, 19, true), -- Tampa (primary)
(19, 6, false),  -- Miami
(19, 7, false),  -- Seattle
(19, 8, false),  -- Atlanta
(19, 9, false),  -- Portland

-- Emily Davis's preferences (Orlando primary, multiple secondary locations)
(20, 20, true), -- Orlando (primary)
(20, 10, false), -- Phoenix
(20, 11, false), -- Denver
(20, 12, false), -- Boston
(20, 13, false); -- Dallas

-- Insert sample messages
INSERT INTO messages (sender_id, receiver_id, product_id, message) VALUES
-- Electronics conversations
(1, 2, 1, 'Hello, I''m interested in your iPhone 13 Pro. Can you tell me more about it?'),
(2, 1, 1, 'Sure, I can send you more details. What''s your name?'),
(1, 2, 1, 'My name is John Doe. Can you send me the details?'),
(2, 1, 1, 'Absolutely, I''ll send you the details right away.'),

-- Fashion conversations
(3, 4, 6, 'Hi, is the leather jacket still available?'),
(4, 3, 6, 'Yes, it is! What size are you looking for?'),
(3, 4, 6, 'I need a size M. Is it genuine leather?'),
(4, 3, 6, 'Yes, it''s 100% genuine leather. Would you like to see more photos?'),

-- Vehicle Parts conversations
(5, 6, 16, 'Hello, I''m interested in the engine block. Is it still available?'),
(6, 5, 16, 'Yes, it is! It''s a rebuilt V8, perfect condition.'),
(5, 6, 16, 'Great! What''s the best price you can do?'),
(6, 5, 16, 'I can do $1800 if you pick it up this week.'),

-- Musical Instruments conversations
(7, 8, 41, 'Hi, is the Fender Stratocaster still for sale?'),
(8, 7, 41, 'Yes, it is! It''s in excellent condition.'),
(7, 8, 41, 'Can you tell me more about its condition?'),
(8, 7, 41, 'It''s a 2019 model, sunburst finish, barely used. No scratches or dents.'),

-- Art & Crafts conversations
(9, 10, 51, 'Hello, I''m interested in the professional paint set. Is it complete?'),
(10, 9, 51, 'Yes, all 24 colors are included and unused.'),
(9, 10, 51, 'Great! Can you ship it to Chicago?'),
(10, 9, 51, 'Yes, I can ship it for an additional $15.'),

-- Jewelry conversations
(11, 12, 56, 'Hi, is the diamond ring still available?'),
(12, 11, 56, 'Yes, it is! It''s a beautiful 1-carat diamond.'),
(11, 12, 56, 'Can you provide the certification?'),
(12, 11, 56, 'Yes, I have the GIA certification. Would you like to see it?'),

-- Collectibles conversations
(13, 14, 61, 'Hello, I''m interested in the comic book collection. Are they all in good condition?'),
(14, 13, 61, 'Yes, they''re all in excellent condition, stored in protective sleeves.'),
(13, 14, 61, 'Can you list the titles included?'),
(14, 13, 61, 'I''ll send you a complete list of all 50 issues.'),

-- Office Supplies conversations
(15, 16, 66, 'Hi, is the desk set still available?'),
(16, 15, 66, 'Yes, it is! It''s a complete executive set.'),
(15, 16, 66, 'Can you tell me what''s included?'),
(16, 15, 66, 'It includes a desk pad, pen holder, letter tray, and business card holder.'),

-- Food & Beverages conversations
(17, 18, 71, 'Hello, I''m interested in the wine collection. Are they all from the same year?'),
(18, 17, 71, 'No, they''re from different years, all premium selections.'),
(17, 18, 71, 'Can you list the wines included?'),
(18, 17, 71, 'I''ll send you the complete list with vintages and regions.'),

-- Baby & Kids conversations
(19, 20, 76, 'Hi, is the stroller still available?'),
(20, 19, 76, 'Yes, it is! It''s a lightweight travel system.'),
(19, 20, 76, 'Does it include the car seat?'),
(20, 19, 76, 'Yes, it comes with the matching car seat and base.'),

-- Health & Fitness conversations
(1, 3, 81, 'Hello, I''m interested in the treadmill. Is it still available?'),
(3, 1, 81, 'Yes, it is! It''s a professional grade model.'),
(1, 3, 81, 'Can you tell me more about its features?'),
(3, 1, 81, 'It has a 3.0 HP motor, 12 preset programs, and heart rate monitoring.'),

-- Garden & Outdoor conversations
(2, 4, 86, 'Hi, is the BBQ grill still for sale?'),
(4, 2, 86, 'Yes, it is! It''s a 4-burner gas grill.'),
(2, 4, 86, 'Does it include the propane tank?'),
(4, 2, 86, 'Yes, it comes with a full 20lb propane tank.'),

-- Tools & Hardware conversations
(5, 7, 91, 'Hello, I''m interested in the power tool set. Is it still available?'),
(7, 5, 91, 'Yes, it is! It''s a complete 5-piece cordless set.'),
(5, 7, 91, 'What brand is it?'),
(7, 5, 91, 'It''s a DeWalt set, all tools are 20V Max.'),

-- Photography conversations
(6, 8, 96, 'Hi, is the DSLR camera still available?'),
(8, 6, 96, 'Yes, it is! It comes with the kit lens.'),
(6, 8, 96, 'What''s the shutter count?'),
(8, 6, 96, 'It has less than 5,000 actuations, barely used.'),

-- Computers & Accessories conversations
(9, 11, 101, 'Hello, I''m interested in the gaming PC. Is it still available?'),
(11, 9, 101, 'Yes, it is! It has an RTX 3080 and 32GB RAM.'),
(9, 11, 101, 'Can you provide the full specs?'),
(11, 9, 101, 'I''ll send you the complete system specifications.'),

-- Gaming conversations
(10, 12, 106, 'Hi, is the PS5 still for sale?'),
(12, 10, 106, 'Yes, it is! It''s the digital edition with games.'),
(10, 12, 106, 'What games are included?'),
(12, 10, 106, 'It comes with God of War Ragnarök and Horizon Forbidden West.'),

-- Antiques conversations
(13, 15, 111, 'Hello, I''m interested in the vintage clock. Is it still available?'),
(15, 13, 111, 'Yes, it is! It''s from the 1800s, working condition.'),
(13, 15, 111, 'Can you provide more details about its history?'),
(15, 13, 111, 'I''ll send you the complete history and documentation.'),

-- Party Supplies conversations
(14, 16, 116, 'Hi, is the party tent still available?'),
(16, 14, 116, 'Yes, it is! It''s a 10x20 feet tent with sides.'),
(14, 16, 116, 'Does it include the stakes and ropes?'),
(16, 14, 116, 'Yes, it comes with all necessary hardware and instructions.'),

-- Travel Gear conversations
(17, 19, 121, 'Hello, I''m interested in the luggage set. Is it still available?'),
(19, 17, 121, 'Yes, it is! It''s a 3-piece hardshell set.'),
(17, 19, 121, 'What are the dimensions?'),
(19, 17, 121, 'I''ll send you the exact dimensions for each piece.'),

-- Pet Supplies conversations
(18, 20, 126, 'Hi, is the dog house still for sale?'),
(20, 18, 126, 'Yes, it is! It''s a weatherproof large size.'),
(18, 20, 126, 'What are the dimensions?'),
(20, 18, 126, 'It''s 36" x 24" x 28", perfect for medium to large dogs.'),

-- Home Improvement conversations
(1, 4, 131, 'Hello, I''m interested in the paint set. Is it still available?'),
(4, 1, 131, 'Yes, it is! It''s 5 gallons of interior paint.'),
(1, 4, 131, 'What color is it?'),
(4, 1, 131, 'It''s a neutral beige, perfect for living rooms.'),

-- Industrial & Scientific conversations
(2, 5, 136, 'Hi, is the microscope still available?'),
(5, 2, 136, 'Yes, it is! It''s a professional 1000x model.'),
(2, 5, 136, 'Does it include any slides?'),
(5, 2, 136, 'Yes, it comes with a set of 10 prepared slides.');

-- Insert default garage items
INSERT INTO garage_items (user_id, name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, is_primary) VALUES
(1, '2021 Honda Civic', '2021 Honda Civic, 2.0L, automatic transmission, 182 hp', 'https://example.com/honda_civic.jpg', 1, 2021, 1, 1, 1, true),
(2, '2019 Toyota Camry', '2019 Toyota Camry, 3.5L, automatic transmission, 301 hp', 'https://example.com/toyota_camry.jpg', 1, 2019, 2, 2, 2, false),
(3, '2020 Tesla Model 3', '2020 Tesla Model 3, 283 hp', 'https://example.com/tesla_model_3.jpg', 1, 2020, 3, 3, 3, false),
(4, '2018 BMW 320i', '2018 BMW 320i, 2.0L, automatic transmission, 248 hp', 'https://example.com/bmw_320i.jpg', 1, 2018, 4, 4, 4, false);

INSERT INTO garage_items (user_id, name, description, image_url, vehicle_type_id, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, vehicle_year, is_primary) VALUES
-- John Doe's vehicles (Tech enthusiast with modern cars)
(1, '2021 Honda Civic', '2021 Honda Civic, 2.0L, automatic transmission, 182 hp', 'https://example.com/honda_civic.jpg', 1, 1, 1, 1, 2021, true),
(1, '2020 Tesla Model 3', '2020 Tesla Model 3, Dual Motor, Long Range', 'https://example.com/tesla_model3.jpg', 1, 3, 3, 3, 2020, false),
(1, '2019 BMW 330i', '2019 BMW 330i, M Sport Package', 'https://example.com/bmw_330i.jpg', 1, 4, 4, 4, 2019, false),

-- Jane Smith's vehicles (Fashion designer with luxury cars)
(2, '2022 Lexus RX', '2022 Lexus RX 350, Premium Package', 'https://example.com/lexus_rx.jpg', 1, 17, 17, 17, 2022, true),
(2, '2021 Mercedes-Benz C-Class', '2021 Mercedes-Benz C300, AMG Line', 'https://example.com/mercedes_c.jpg', 1, 16, 16, 16, 2021, false),
(2, '2020 Porsche 911', '2020 Porsche 911 Carrera S', 'https://example.com/porsche_911.jpg', 1, 21, 21, 21, 2020, false),

-- Mike Wilson's vehicles (Sports equipment seller with SUVs)
(3, '2022 Ford Explorer', '2022 Ford Explorer ST, 3.0L EcoBoost', 'https://example.com/ford_explorer.jpg', 1, 9, 9, 9, 2022, true),
(3, '2021 Chevrolet Tahoe', '2021 Chevrolet Tahoe Z71', 'https://example.com/chevy_tahoe.jpg', 1, 10, 10, 10, 2021, false),
(3, '2020 Jeep Grand Cherokee', '2020 Jeep Grand Cherokee Trailhawk', 'https://example.com/jeep_gc.jpg', 1, 22, 22, 22, 2020, false),

-- Sarah Jones's vehicles (Art collector with classic cars)
(4, '1967 Ford Mustang', '1967 Ford Mustang Fastback, 289 V8', 'https://example.com/mustang_67.jpg', 1, 9, 9, 9, 1967, true),
(4, '1970 Chevrolet Camaro', '1970 Chevrolet Camaro SS, 350 V8', 'https://example.com/camaro_70.jpg', 1, 10, 10, 10, 1970, false),
(4, '1969 Dodge Charger', '1969 Dodge Charger R/T, 440 Magnum', 'https://example.com/charger_69.jpg', 1, 11, 11, 11, 1969, false),

-- Alex Chen's vehicles (Car enthusiast with performance cars)
(5, '2023 Toyota Supra', '2023 Toyota Supra 3.0, Premium', 'https://example.com/supra_23.jpg', 1, 2, 2, 2, 2023, true),
(5, '2022 Nissan GT-R', '2022 Nissan GT-R Premium', 'https://example.com/gtr_22.jpg', 1, 12, 12, 12, 2022, false),
(5, '2021 Audi RS7', '2021 Audi RS7 Sportback', 'https://example.com/audi_rs7.jpg', 1, 15, 15, 15, 2021, false),

-- Emma Rodriguez's vehicles (Vintage car restorer)
(6, '1957 Chevrolet Bel Air', '1957 Chevrolet Bel Air, 283 V8', 'https://example.com/belair_57.jpg', 1, 10, 10, 10, 1957, true),
(6, '1963 Corvette Stingray', '1963 Corvette Stingray Split Window', 'https://example.com/corvette_63.jpg', 1, 10, 10, 10, 1963, false),
(6, '1955 Ford Thunderbird', '1955 Ford Thunderbird, 292 V8', 'https://example.com/tbird_55.jpg', 1, 9, 9, 9, 1955, false),

-- David Kim's vehicles (Auto parts specialist with trucks)
(7, '2023 Ford F-150', '2023 Ford F-150 Raptor', 'https://example.com/f150_23.jpg', 3, 9, 9, 9, 2023, true),
(7, '2022 Ram 2500', '2022 Ram 2500 Power Wagon', 'https://example.com/ram_2500.jpg', 3, 24, 24, 24, 2022, false),
(7, '2021 GMC Sierra', '2021 GMC Sierra AT4', 'https://example.com/sierra_21.jpg', 3, 23, 23, 23, 2021, false),

-- Lisa Patel's vehicles (Classic car collector)
(8, '1969 Pontiac GTO', '1969 Pontiac GTO Judge', 'https://example.com/gto_69.jpg', 1, 25, 25, 25, 1969, true),
(8, '1971 Plymouth Hemi Cuda', '1971 Plymouth Hemi Cuda', 'https://example.com/cuda_71.jpg', 1, 26, 26, 26, 1971, false),
(8, '1968 Chevrolet Corvette', '1968 Chevrolet Corvette Stingray', 'https://example.com/corvette_68.jpg', 1, 10, 10, 10, 1968, false),

-- James Wilson's vehicles (Performance parts dealer)
(9, '2023 Dodge Challenger', '2023 Dodge Challenger Hellcat Redeye', 'https://example.com/challenger_23.jpg', 1, 11, 11, 11, 2023, true),
(9, '2022 Chevrolet Camaro', '2022 Chevrolet Camaro ZL1', 'https://example.com/camaro_22.jpg', 1, 10, 10, 10, 2022, false),
(9, '2021 Ford Mustang', '2021 Ford Mustang GT500', 'https://example.com/mustang_21.jpg', 1, 9, 9, 9, 2021, false),

-- Maria Garcia's vehicles (Auto repair shop owner)
(10, '2023 Toyota Tacoma', '2023 Toyota Tacoma TRD Pro', 'https://example.com/tacoma_23.jpg', 3, 2, 2, 2, 2023, true),
(10, '2022 Honda Ridgeline', '2022 Honda Ridgeline Black Edition', 'https://example.com/ridgeline_22.jpg', 3, 1, 1, 1, 2022, false),
(10, '2021 Ford Ranger', '2021 Ford Ranger FX4', 'https://example.com/ranger_21.jpg', 3, 9, 9, 9, 2021, false),

-- Robert Taylor's vehicles (Motorcycle parts specialist)
(11, '2023 Harley-Davidson', '2023 Harley-Davidson Street Bob', 'https://example.com/harley_23.jpg', 2, 5, 5, 5, 2023, true),
(11, '2022 Kawasaki Ninja', '2022 Kawasaki Ninja ZX-10R', 'https://example.com/ninja_22.jpg', 2, 6, 6, 6, 2022, false),
(11, '2021 Yamaha R1', '2021 Yamaha R1M', 'https://example.com/r1_21.jpg', 2, 8, 8, 8, 2021, false),

-- Sophie Martin's vehicles (Car audio system expert)
(12, '2023 Lexus IS', '2023 Lexus IS 500 F Sport', 'https://example.com/lexus_is.jpg', 1, 17, 17, 17, 2023, true),
(12, '2022 Acura TLX', '2022 Acura TLX Type S', 'https://example.com/acura_tlx.jpg', 1, 28, 28, 28, 2022, false),
(12, '2021 Genesis G70', '2021 Genesis G70 3.3T', 'https://example.com/genesis_g70.jpg', 1, 30, 30, 30, 2021, false),

-- Michael Brown's vehicles (Truck parts dealer)
(13, '2023 Chevrolet Silverado', '2023 Chevrolet Silverado 2500HD', 'https://example.com/silverado_23.jpg', 3, 10, 10, 10, 2023, true),
(13, '2022 Ford F-250', '2022 Ford F-250 Super Duty', 'https://example.com/f250_22.jpg', 3, 9, 9, 9, 2022, false),
(13, '2021 GMC Sierra', '2021 GMC Sierra 3500HD', 'https://example.com/sierra_21.jpg', 3, 23, 23, 23, 2021, false),

-- Anna Kowalski's vehicles (Electric vehicle specialist)
(14, '2023 Tesla Model S', '2023 Tesla Model S Plaid', 'https://example.com/tesla_s.jpg', 1, 3, 3, 3, 2023, true),
(14, '2022 Porsche Taycan', '2022 Porsche Taycan Turbo S', 'https://example.com/taycan_22.jpg', 1, 21, 21, 21, 2022, false),
(14, '2021 Audi e-tron', '2021 Audi e-tron GT', 'https://example.com/etron_21.jpg', 1, 15, 15, 15, 2021, false),

-- Thomas Nguyen's vehicles (Import car parts dealer)
(15, '2023 Subaru WRX', '2023 Subaru WRX STI', 'https://example.com/wrx_23.jpg', 1, 13, 13, 13, 2023, true),
(15, '2022 Mitsubishi Lancer', '2022 Mitsubishi Lancer Evolution', 'https://example.com/lancer_22.jpg', 1, 31, 31, 31, 2022, false),
(15, '2021 Nissan Skyline', '2021 Nissan Skyline GT-R', 'https://example.com/skyline_21.jpg', 1, 12, 12, 12, 2021, false),

-- Olivia Lee's vehicles (Luxury car parts specialist)
(16, '2023 Mercedes-Benz S-Class', '2023 Mercedes-Benz S580', 'https://example.com/sclass_23.jpg', 1, 16, 16, 16, 2023, true),
(16, '2022 BMW 7 Series', '2022 BMW 760i', 'https://example.com/7series_22.jpg', 1, 4, 4, 4, 2022, false),
(16, '2021 Lexus LS', '2021 Lexus LS 500', 'https://example.com/ls_21.jpg', 1, 17, 17, 17, 2021, false),

-- William Clark's vehicles (Off-road parts dealer)
(17, '2023 Jeep Wrangler', '2023 Jeep Wrangler Rubicon 392', 'https://example.com/wrangler_23.jpg', 1, 22, 22, 22, 2023, true),
(17, '2022 Ford Bronco', '2022 Ford Bronco Wildtrak', 'https://example.com/bronco_22.jpg', 1, 9, 9, 9, 2022, false),
(17, '2021 Toyota 4Runner', '2021 Toyota 4Runner TRD Pro', 'https://example.com/4runner_21.jpg', 1, 2, 2, 2, 2021, false),

-- Isabella Moore's vehicles (Vintage motorcycle collector)
(18, '1969 Harley-Davidson', '1969 Harley-Davidson Electra Glide', 'https://example.com/harley_69.jpg', 2, 5, 5, 5, 1969, true),
(18, '1972 Triumph', '1972 Triumph Bonneville', 'https://example.com/triumph_72.jpg', 2, 32, 32, 32, 1972, false),
(18, '1975 Ducati', '1975 Ducati 750SS', 'https://example.com/ducati_75.jpg', 2, 33, 33, 33, 1975, false),

-- Daniel White's vehicles (Performance tuning expert)
(19, '2023 BMW M3', '2023 BMW M3 Competition', 'https://example.com/m3_23.jpg', 1, 4, 4, 4, 2023, true),
(19, '2022 Audi RS3', '2022 Audi RS3 Sportback', 'https://example.com/rs3_22.jpg', 1, 15, 15, 15, 2022, false),
(19, '2021 Mercedes-AMG', '2021 Mercedes-AMG C63 S', 'https://example.com/c63_21.jpg', 1, 16, 16, 16, 2021, false),

-- Emily Davis's vehicles (Auto body parts specialist)
(20, '2023 Cadillac Escalade', '2023 Cadillac Escalade-V', 'https://example.com/escalade_23.jpg', 1, 26, 26, 26, 2023, true),
(20, '2022 Lincoln Navigator', '2022 Lincoln Navigator Black Label', 'https://example.com/navigator_22.jpg', 1, 27, 27, 27, 2022, false),
(20, '2021 Infiniti QX80', '2021 Infiniti QX80 Sensory', 'https://example.com/qx80_21.jpg', 1, 29, 29, 29, 2021, false);


