package database;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBTesting {
    public static void main(String[] args) {
	    try {
	        Connection conn = DBConnection.getConnection();
	        System.out.println("Database connected!");
	
	        Statement stmt = conn.createStatement();
	
	        stmt.executeUpdate(
	            "CREATE TABLE IF NOT EXISTS Sample_Jobs (" +
	            "job_id INT PRIMARY KEY, " +
	            "company_name VARCHAR(50), " +
	            "job_name VARCHAR(50), " +
	            "job_location VARCHAR(50), " +
	            "job_skill VARCHAR(50))"
	        );
	
	        stmt.executeUpdate(
	            "INSERT INTO Sample_Jobs " +
	            "(job_id, company_name, job_name, job_location, job_skill) VALUES " +
	            "(1, 'Apple', 'Software Engineer', 'Cupertino', 'Programming'), " +
	            "(2, 'Google', 'Data Engineer', 'Sunnyvale', 'SQL'), " +
	            "(3, 'SJSU', 'Instructor', 'San Jose', 'Teaching')"
	        );
	
	        ResultSet rs = stmt.executeQuery(
	            "SELECT * FROM Sample_Jobs"
	        );
	
	        while (rs.next()) {
	            System.out.println(
	                rs.getInt("job_id") + " | " +
	                rs.getString("company_name") + " | " +
	                rs.getString("job_name") + " | " +
	                rs.getString("job_location") + " | " +
	                rs.getString("job_skill")
	            );
	        }
	
	        conn.close();
	
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
    }
}
