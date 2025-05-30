drop table if exists notifications;
drop table if exists messages;
drop table if exists saved_products;
drop table if exists reviews;
drop table if exists orders;
drop table if exists search_history;
drop table if exists settings;
drop table if exists reports;
drop table if exists bans;
drop table if exists user_suspensions;
drop table if exists user_interactions;
drop table if exists user_preferences;
drop table if exists product_popularity;
drop table if exists products;
drop table if exists categories;
drop table if exists user_location_preferences;
drop table if exists garage_items;
drop table if exists users;
drop table if exists cities;
drop table if exists states;
drop table if exists countries;
drop table if exists vehicle_submodels;
drop table if exists vehicle_models;
drop table if exists vehicle_makes;
drop table if exists vehicle_types;

-- Create tables
CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(2) UNIQUE NOT NULL, -- ISO 3166-1 alpha-2 country code
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE states (
    id SERIAL PRIMARY KEY,
    country_id INTEGER REFERENCES countries(id),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10), -- State/province code (e.g., CA for California)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(country_id, name)
);

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    state_id INTEGER REFERENCES states(id),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(state_id, name)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    city_id INTEGER REFERENCES cities(id),
    profile_image_url VARCHAR(255),
    bio TEXT,
    phone_number VARCHAR(20),
    is_verified BOOLEAN DEFAULT FALSE,
    last_active TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    icon VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    condition VARCHAR(50),
    city_id INTEGER REFERENCES cities(id),
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    buyer_id INTEGER REFERENCES users(id),
    seller_id INTEGER REFERENCES users(id),
    product_id INTEGER REFERENCES products(id),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    reviewer_id INTEGER REFERENCES users(id),
    reviewed_id INTEGER REFERENCES users(id),
    order_id INTEGER REFERENCES orders(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    related_id INTEGER, -- Can reference product_id, message_id, etc.
    related_type VARCHAR(50), -- 'product', 'message', 'offer', etc.
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE search_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    query VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    filters JSONB, -- Store additional search filters as JSON
    result_count INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    notification_settings JSONB, -- Store notification preferences as JSON
    saved_items JSONB, -- Store saved items as JSON
    order_history JSONB, -- Store order history as JSON
    review_history JSONB, -- Store review history as JSON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_interactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    interaction_type VARCHAR(20) NOT NULL, -- 'view', 'favorite', 'purchase', 'message'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, product_id, interaction_type)
);

CREATE TABLE product_popularity (
    product_id INTEGER PRIMARY KEY REFERENCES products(id) ON DELETE CASCADE,
    view_count INTEGER DEFAULT 0,
    favorite_count INTEGER DEFAULT 0,
    message_count INTEGER DEFAULT 0,
    purchase_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_preferences (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    preferred_categories JSONB, -- Array of preferred categories
    preferred_price_range JSONB, -- {min: number, max: number}
    preferred_locations JSONB, -- Array of preferred locations
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    reported_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    report_type VARCHAR(50) NOT NULL,
    validation BOOLEAN DEFAULT FALSE,
    ban BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bans (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_suspensions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    suspension_type VARCHAR(50) NOT NULL,
    reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create user location preferences table
CREATE TABLE user_location_preferences (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    city_id INTEGER REFERENCES cities(id),
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, city_id)
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    receiver_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE saved_products (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, product_id)
);

-- Create vehicle tables with hierarchy
CREATE TABLE vehicle_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_makes (
    id SERIAL PRIMARY KEY,
    type_id INTEGER REFERENCES vehicle_types(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(type_id, name)
);

CREATE TABLE vehicle_models (
    id SERIAL PRIMARY KEY,
    make_id INTEGER REFERENCES vehicle_makes(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(make_id, name)
);

CREATE TABLE vehicle_submodels (
    id SERIAL PRIMARY KEY,
    model_id INTEGER REFERENCES vehicle_models(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(model_id, name)
);

CREATE TABLE garage_items (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    vehicle_type_id INTEGER REFERENCES vehicle_types(id),
    vehicle_year INTEGER,
    vehicle_make_id INTEGER REFERENCES vehicle_makes(id),
    vehicle_model_id INTEGER REFERENCES vehicle_models(id),
    vehicle_submodel_id INTEGER REFERENCES vehicle_submodels(id),
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster notification queries
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Create index for faster review queries
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);
CREATE INDEX idx_reviews_reviewed_id ON reviews(reviewed_id);
CREATE INDEX idx_reviews_order_id ON reviews(order_id);

-- Create index for faster order queries
CREATE INDEX idx_orders_buyer_id ON orders(buyer_id);
CREATE INDEX idx_orders_seller_id ON orders(seller_id);

-- Create index for faster product queries
CREATE INDEX idx_products_user_id ON products(user_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_city_id ON products(city_id);

-- Create index for faster search queries
CREATE INDEX idx_products_search ON products USING GIN (to_tsvector('english', title || ' ' || description || ' ' || city_id));

-- Create index for faster settings queries
CREATE INDEX idx_settings_user_id ON settings(user_id);

-- Create index for search history
CREATE INDEX idx_search_history_user_id ON search_history(user_id);
CREATE INDEX idx_search_history_created_at ON search_history(created_at);
CREATE INDEX idx_search_history_query ON search_history(query);

-- Create indexes for user interactions
CREATE INDEX idx_user_interactions_user_id ON user_interactions(user_id);
CREATE INDEX idx_user_interactions_product_id ON user_interactions(product_id);
CREATE INDEX idx_user_interactions_type ON user_interactions(interaction_type);

-- Create index for product popularity
CREATE INDEX idx_product_popularity_view_count ON product_popularity(view_count);
CREATE INDEX idx_product_popularity_favorite_count ON product_popularity(favorite_count);
CREATE INDEX idx_product_popularity_purchase_count ON product_popularity(purchase_count);

-- Create index for user preferences
CREATE INDEX idx_user_preferences_preferred_categories ON user_preferences(preferred_categories);
CREATE INDEX idx_user_preferences_preferred_price_range ON user_preferences(preferred_price_range);
CREATE INDEX idx_user_preferences_preferred_locations ON user_preferences(preferred_locations);

-- Create index for location queries
CREATE INDEX idx_countries_name ON countries(name);
CREATE INDEX idx_states_country_id ON states(country_id);
CREATE INDEX idx_states_name ON states(name);
CREATE INDEX idx_cities_state_id ON cities(state_id);
CREATE INDEX idx_cities_name ON cities(name);

-- Create index for report queries
CREATE INDEX idx_reports_user_id ON reports(user_id);
CREATE INDEX idx_reports_reported_user_id ON reports(reported_user_id);

-- Create index for ban queries
CREATE INDEX idx_bans_user_id ON bans(user_id);

-- Create index for user suspension queries
CREATE INDEX idx_user_suspensions_user_id ON user_suspensions(user_id);

-- Create indexes for user location queries
CREATE INDEX idx_users_city_id ON users(city_id);
CREATE INDEX idx_user_location_preferences_user_id ON user_location_preferences(user_id);
CREATE INDEX idx_user_location_preferences_city_id ON user_location_preferences(city_id);

-- Indexes for faster message queries
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX idx_messages_product_id ON messages(product_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);

-- Indexes for faster saved products queries
CREATE INDEX idx_saved_products_user_id ON saved_products(user_id);
CREATE INDEX idx_saved_products_product_id ON saved_products(product_id);

-- Create index for faster garage item queries
CREATE INDEX idx_garage_items_user_id ON garage_items(user_id);
CREATE INDEX idx_garage_items_created_at ON garage_items(created_at);
CREATE INDEX idx_garage_items_is_primary ON garage_items(is_primary);

-- Create indexes for faster vehicle queries
CREATE INDEX idx_vehicle_makes_type_id ON vehicle_makes(type_id);
CREATE INDEX idx_vehicle_models_make_id ON vehicle_models(make_id);
CREATE INDEX idx_vehicle_submodels_model_id ON vehicle_submodels(model_id);
CREATE INDEX idx_garage_items_vehicle_type_id ON garage_items(vehicle_type_id);
CREATE INDEX idx_garage_items_vehicle_make_id ON garage_items(vehicle_make_id);
CREATE INDEX idx_garage_items_vehicle_model_id ON garage_items(vehicle_model_id);
CREATE INDEX idx_garage_items_vehicle_submodel_id ON garage_items(vehicle_submodel_id);

-- Create indexes for faster vehicle type queries
CREATE INDEX idx_vehicle_types_name ON vehicle_types(name);

-- Create indexes for faster vehicle make queries
CREATE INDEX idx_vehicle_makes_name ON vehicle_makes(name);


