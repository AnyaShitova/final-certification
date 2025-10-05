-- Запросы на чтение
-- 1. Список всех заказов за последние 7 дней
SELECT o.order_date, c.first_name, c.last_name, p.description
FROM "order" o
JOIN customer c ON o.customer_id = c.id
JOIN product p ON o.product_id = p.id
WHERE o.order_date > CURRENT_DATE - INTERVAL '7 days';

-- 2. Топ-3 самых популярных товаров
SELECT p.description, COUNT(o.id) AS order_count
FROM "order" o
JOIN product p ON o.product_id = p.id
GROUP BY p.description
ORDER BY order_count DESC
LIMIT 3;

-- Запросы на изменение
-- 3. Обновление количества товара на складе
UPDATE product
SET quantity = quantity - 1
WHERE id = 1;

-- Запросы на удаление
-- 4. Удаление клиентов без заказов
DELETE FROM customer
WHERE id NOT IN (SELECT customer_id FROM "order");