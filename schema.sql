-- Создание таблицы product (товары)
CREATE TABLE IF NOT EXISTS product (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(100) NOT NULL
);
COMMENT ON TABLE product IS 'Таблица товаров';
COMMENT ON COLUMN product.description IS 'Описание товара';
COMMENT ON COLUMN product.price IS 'Цена товара (должна быть >= 0)';
COMMENT ON COLUMN product.quantity IS 'Количество товара на складе (должно быть >= 0)';
COMMENT ON COLUMN product.category IS 'Категория товара';

-- Создание таблицы customer (покупатели)
CREATE TABLE IF NOT EXISTS customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL
);
COMMENT ON TABLE customer IS 'Таблица покупателей';
COMMENT ON COLUMN customer.first_name IS 'Имя покупателя';
COMMENT ON COLUMN customer.last_name IS 'Фамилия покупателя';
COMMENT ON COLUMN customer.phone IS 'Телефон покупателя';
COMMENT ON COLUMN customer.email IS 'Email покупателя (уникальный)';

-- Создание таблицы order_status (статусы заказов)
CREATE TABLE IF NOT EXISTS order_status (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE order_status IS 'Справочник статусов заказов';
COMMENT ON COLUMN order_status.status_name IS 'Название статуса заказа';

-- Создание таблицы order (заказы)
CREATE TABLE IF NOT EXISTS "order" (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    customer_id INT NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    status_id INT NOT NULL REFERENCES order_status(id)
);
COMMENT ON TABLE "order" IS 'Таблица заказов';
COMMENT ON COLUMN "order".product_id IS 'Ссылка на товар (FK)';
COMMENT ON COLUMN "order".customer_id IS 'Ссылка на покупателя (FK)';
COMMENT ON COLUMN "order".order_date IS 'Дата заказа';
COMMENT ON COLUMN "order".quantity IS 'Количество товара в заказе (должно быть > 0)';
COMMENT ON COLUMN "order".status_id IS 'Ссылка на статус заказа (FK)';

-- Создание индексов
CREATE INDEX idx_order_date ON "order"(order_date);
CREATE INDEX idx_product_id ON "order"(product_id);
CREATE INDEX idx_customer_id ON "order"(customer_id);

-- Заполнение таблицы product (10 записей)
INSERT INTO product (description, price, quantity, category) VALUES
('Смартфон', 30000, 10, 'Электроника'),
('Ноутбук', 70000, 5, 'Электроника'),
('Микроволновая печь', 15000, 20, 'Бытовая техника'),
('Кофемашина', 25000, 15, 'Бытовая техника'),
('Наушники', 5000, 30, 'Электроника'),
('Планшет', 40000, 8, 'Электроника'),
('Монитор', 20000, 12, 'Электроника'),
('Принтер', 18000, 7, 'Офисная техника'),
('Фотоаппарат', 35000, 4, 'Фототехника'),
('Телевизор', 50000, 6, 'Электроника');

-- Заполнение таблицы customer (10 записей)
INSERT INTO customer (first_name, last_name, phone, email) VALUES
('Иван', 'Иванов', '1234567890', 'ivan@example.com'),
('Петр', 'Петров', '0987654321', 'petr@example.com'),
('Анна', 'Сидорова', '1112223333', 'anna@example.com'),
('Мария', 'Кузнецова', '4445556666', 'maria@example.com'),
('Алексей', 'Смирнов', '7778889999', 'alexey@example.com'),
('Елена', 'Попова', '0001112222', 'elena@example.com'),
('Дмитрий', 'Васильев', '3334445555', 'dmitry@example.com'),
('Ольга', 'Новикова', '6667778888', 'olga@example.com'),
('Сергей', 'Морозов', '9990001111', 'sergey@example.com'),
('Татьяна', 'Козлова', '2223334444', 'tatyana@example.com');

-- Заполнение таблицы order_status (3 записи)
INSERT INTO order_status (status_name) VALUES
('Оформлен'),
('Оплачен'),
('Доставлен');

-- Заполнение таблицы order (10 записей)
INSERT INTO "order" (product_id, customer_id, order_date, quantity, status_id) VALUES
(1, 1, '2023-10-01', 1, 1),
(2, 2, '2023-10-02', 1, 2),
(3, 3, '2023-10-03', 2, 1),
(4, 4, '2023-10-04', 1, 3),
(5, 5, '2023-10-05', 3, 1),
(6, 6, '2023-10-06', 1, 2),
(7, 7, '2023-10-07', 2, 1),
(8, 8, '2023-10-08', 1, 3),
(9, 9, '2023-10-09', 4, 1),
(10, 10, '2023-10-10', 1, 2);