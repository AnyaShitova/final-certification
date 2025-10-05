-- Запросы на чтение

-- 1. Список всех заказов в диапазоне дат с именем покупателя и описанием товара
SELECT o.order_date, c.first_name, c.last_name, p.description
FROM "order" o
JOIN customer c ON o.customer_id = c.id
JOIN product p ON o.product_id = p.id
WHERE o.order_date BETWEEN '2023-10-01' AND '2023-10-07';

-- 2. Топ-3 самых популярных товаров (по количеству заказов)
SELECT p.description, SUM(o.quantity) AS total_ordered
FROM "order" o
JOIN product p ON o.product_id = p.id
GROUP BY p.description
ORDER BY total_ordered DESC
LIMIT 3;

-- 3. Общая стоимость всех заказов каждого клиента
SELECT c.first_name, c.last_name, SUM(p.price * o.quantity) AS total_spent
FROM "order" o
JOIN customer c ON o.customer_id = c.id
JOIN product p ON o.product_id = p.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 4. Список товаров с количеством меньше 10 на складе
SELECT description, quantity
FROM product
WHERE quantity < 10;

-- 5. Заказы, которые были оплачены, но еще не доставлены
SELECT o.id, o.order_date, p.description, os.status_name
FROM "order" o
JOIN product p ON o.product_id = p.id
JOIN order_status os ON o.status_id = os.id
WHERE os.status_name = 'Оплачен';

-- Запросы на изменение

-- 6. Обновление количества на складе при покупке (например, после оформления заказа)
UPDATE product
SET quantity = quantity - 1
WHERE id IN (SELECT product_id FROM "order");

-- 7. Обновление статуса заказа на "Доставлен" для старых заказов
UPDATE "order"
SET status_id = (SELECT id FROM order_status WHERE status_name = 'Доставлен')
WHERE order_date <= CURRENT_DATE - INTERVAL '7 days';

-- 8. Увеличение цены товара на 10% для категории "Электроника"
UPDATE product
SET price = price * 1.10
WHERE category = 'Электроника';

-- Запросы на удаление

-- 9. Удаление клиентов без заказов
DELETE FROM customer
WHERE id NOT IN (SELECT customer_id FROM "order");

-- 10. Удаление товаров с нулевым количеством на складе
DELETE FROM product
WHERE quantity = 0;