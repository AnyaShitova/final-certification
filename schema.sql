-- Таблица товаров
CREATE TABLE IF NOT EXISTS product (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    quantity INT CHECK (quantity >= 0),
    category VARCHAR(100)
);
COMMENT ON TABLE product IS 'Таблица товаров';
COMMENT ON COLUMN product.price IS 'Цена товара (должна быть >= 0)';

-- Таблица покупателей
CREATE TABLE IF NOT EXISTS customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);
COMMENT ON TABLE customer IS 'Таблица покупателей';

-- Таблица статусов заказов
CREATE TABLE IF NOT EXISTS order_status (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE order_status IS 'Справочник статусов заказов';

-- Таблица заказов
CREATE TABLE IF NOT EXISTS "order" (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES product(id) ON DELETE CASCADE,
    customer_id INT REFERENCES customer(id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    quantity INT CHECK (quantity > 0),
    status_id INT REFERENCES order_status(id)
);
COMMENT ON TABLE "order" IS 'Таблица заказов';
CREATE INDEX order_date_idx ON "order"(order_date);

-- Заполнение тестовыми данными
INSERT INTO product (description, price, quantity, category) VALUES
('Смартфон', 30000, 10, 'Электроника'),
('Ноутбук', 70000, 5, 'Электроника'),
('Кофеварка', 15000, 20, 'Бытовая техника');

INSERT INTO customer (first_name, last_name, phone, email) VALUES
('Иван', 'Иванов', '1234567890', 'ivan@example.com'),
('Петр', 'Петров', '0987654321', 'petr@example.com');

INSERT INTO order_status (status_name) VALUES
('Оформлен'),
('Оплачен'),
('Доставлен');

INSERT INTO "order" (product_id, customer_id, order_date, quantity, status_id) VALUES
(1, 1, '2023-10-01', 1, 1),
(2, 2, '2023-10-02', 2, 2);