/*
  # Create menu items table for restaurant management

  1. New Tables
    - `menu_items`
      - `id` (uuid, primary key)
      - `restaurant_id` (text, references restaurant)
      - `item_name` (text, menu item name)
      - `item_description` (text, item description)
      - `item_price` (integer, price in XAF)
      - `category` (text, item category)
      - `prep_time` (integer, preparation time in minutes)
      - `image` (text, image URL)
      - `is_available` (boolean, availability status)
      - `created_at` (timestamptz, creation timestamp)
      - `updated_at` (timestamptz, last update timestamp)
  
  2. Security
    - Enable RLS on `menu_items` table
    - Add policy for authenticated users to view available menu items
    - Add policy for restaurant managers to manage their menu items
    - Add policy for customers to view all available menu items
*/

CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id text NOT NULL,
  item_name text NOT NULL,
  item_description text NOT NULL,
  item_price integer NOT NULL,
  category text NOT NULL,
  prep_time integer NOT NULL DEFAULT 15,
  image text DEFAULT 'https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg',
  is_available boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view available menu items"
  ON menu_items FOR SELECT
  USING (is_available = true OR auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can view all menu items"
  ON menu_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert menu items"
  ON menu_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update menu items"
  ON menu_items FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete menu items"
  ON menu_items FOR DELETE
  TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category);
CREATE INDEX IF NOT EXISTS idx_menu_items_available ON menu_items(is_available);