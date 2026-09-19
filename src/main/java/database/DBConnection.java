package database;
import java.sql.*;
public class DBConnection {
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(
            MysqlCon.URL,
            MysqlCon.USER,
            MysqlCon.PASSWORD
        );
    }
}
