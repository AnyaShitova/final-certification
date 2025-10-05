package org.example;

import java.sql.*;
import java.util.Properties;

public class App {
    public static void main(String[] args) {
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        props.setProperty("password", "123");

        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/final_certification", props)) {
            // 1. Вставка нового товара (Create)
            insertNewProduct(conn, "Телевизор", 50000, 15, "Электроника");

            // 2. Вставка нового покупателя (Create)
            insertNewCustomer(conn, "Александр", "Пушкин", "1231231234", "alex@example.com");

            // 3. Создание заказа для покупателя (Create)
            createOrder(conn, 1, 1, "2023-10-11", 2, 1);

            // 4. Чтение и вывод последних 5 заказов (Read)
            printLast5Orders(conn);

            // 5. Обновление цены товара и количества на складе (Update)
            updateProductPrice(conn, 1, 55000);
            updateProductQuantity(conn, 1, 10);

            // 6. Удаление тестовых записей (Delete)
            deleteTestCustomer(conn, "alex@example.com");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Метод для вставки нового товара
    private static void insertNewProduct(Connection conn, String description, double price, int quantity, String category) throws SQLException {
        String sql = "INSERT INTO product (description, price, quantity, category) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, description);
            pstmt.setDouble(2, price);
            pstmt.setInt(3, quantity);
            pstmt.setString(4, category);
            pstmt.executeUpdate();
            System.out.println("Новый товар добавлен: " + description);
        }
    }

    // Метод для вставки нового покупателя
    private static void insertNewCustomer(Connection conn, String firstName, String lastName, String phone, String email) throws SQLException {
        String sql = "INSERT INTO customer (first_name, last_name, phone, email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, phone);
            pstmt.setString(4, email);
            pstmt.executeUpdate();
            System.out.println("Новый покупатель добавлен: " + firstName + " " + lastName);
        }
    }

    // Метод для создания заказа
    private static void createOrder(Connection conn, int productId, int customerId, String orderDate, int quantity, int statusId) throws SQLException {
        String sql = "INSERT INTO \"order\" (product_id, customer_id, order_date, quantity, status_id) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            pstmt.setInt(2, customerId);
            pstmt.setDate(3, Date.valueOf(orderDate));
            pstmt.setInt(4, quantity);
            pstmt.setInt(5, statusId);
            pstmt.executeUpdate();
            System.out.println("Новый заказ создан.");
        }
    }

    // Метод для чтения и вывода последних 5 заказов
    private static void printLast5Orders(Connection conn) throws SQLException {
        String sql = "SELECT o.order_date, c.first_name, c.last_name, p.description " +
                "FROM \"order\" o " +
                "JOIN customer c ON o.customer_id = c.id " +
                "JOIN product p ON o.product_id = p.id " +
                "ORDER BY o.order_date DESC LIMIT 5";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            System.out.println("\nПоследние 5 заказов:");
            while (rs.next()) {
                System.out.println(rs.getString("order_date") + " " +
                        rs.getString("first_name") + " " +
                        rs.getString("last_name") + " " +
                        rs.getString("description"));
            }
        }
    }

    // Метод для обновления цены товара
    private static void updateProductPrice(Connection conn, int productId, double newPrice) throws SQLException {
        String sql = "UPDATE product SET price = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDouble(1, newPrice);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            System.out.println("Цена товара обновлена.");
        }
    }

    // Метод для обновления количества товара на складе
    private static void updateProductQuantity(Connection conn, int productId, int newQuantity) throws SQLException {
        String sql = "UPDATE product SET quantity = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            System.out.println("Количество товара обновлено.");
        }
    }

    // Метод для удаления тестового покупателя
    private static void deleteTestCustomer(Connection conn, String email) throws SQLException {
        String sql = "DELETE FROM customer WHERE email = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.executeUpdate();
            System.out.println("Покупатель с email " + email + " удален.");
        }
    }
}