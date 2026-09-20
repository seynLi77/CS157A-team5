package dao;
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
	            "CREATE TABLE IF NOT EXISTS job_postings (" +
	            "job_id INT PRIMARY KEY, " +
	            "is_open BOOLEAN, " +
	            "company_name VARCHAR(50), " +
	            "job_name VARCHAR(50), " +
	            "job_location VARCHAR(50), " +
	            "job_skill VARCHAR(50))"
	        );
	
	        stmt.executeUpdate(
	            "INSERT INTO job_postings " +
	            "(job_id, is_open, company_name, job_name, job_location, job_skill) VALUES " +
	            "(1, TRUE, 'Apple', 'Software Engineer', 'Cupertino', 'Programming'), " +
	            "(2, FALSE, 'Google', 'Data Engineer', 'Sunnyvale', 'SQL'), " +
	            "(3, TRUE, 'SJSU', 'Instructor', 'San Jose', 'Teaching')"
	        );
	
	        ResultSet rs = stmt.executeQuery(
	            "SELECT * FROM job_postings"
	        );
	
	        while (rs.next()) {
	            System.out.println(
	                rs.getInt("job_id") + " | " +
	                rs.getBoolean("is_open")+ " | " +
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
