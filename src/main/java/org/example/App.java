package org.example;

import java.sql.*;
import java.util.Properties;

public class App {
    public static void main(String[] args) {
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        props.setProperty("password", "123");

        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", props)) {
            // Вставка нового товара
            String insertProductSQL = "INSERT INTO product (description, price, quantity, category) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertProductSQL)) {
                pstmt.setString(1, "Телевизор");
                pstmt.setDouble(2, 50000);
                pstmt.setInt(3, 15);
                pstmt.setString(4, "Электроника");
                pstmt.executeUpdate();
            }

            // Чтение последних 5 заказов
            String selectOrdersSQL = "SELECT o.order_date, c.first_name, c.last_name, p.description " +
                    "FROM \"order\" o " +
                    "JOIN customer c ON o.customer_id = c.id " +
                    "JOIN product p ON o.product_id = p.id " +
                    "ORDER BY o.order_date DESC LIMIT 5";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(selectOrdersSQL)) {
                while (rs.next()) {
                    System.out.println(rs.getString("order_date") + " " +
                            rs.getString("first_name") + " " +
                            rs.getString("last_name") + " " +
                            rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
