import java.sql.*;

public class TestDB {
    public static void main(String[] args) throws Exception {
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=UTC",
                "root", "2510"
        );
        System.out.println("Connected!");
    }
}
