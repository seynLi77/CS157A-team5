package com.lockedin.test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.lockedin.util.DBConnection;

/**
 * Runs a basic database connection and job-posting table test.
 * 
 * @author Elaine
 */
public class DBTesting {
	/**
	 * Creates sample job postings and prints the stored records.
	 *
	 * @param args command-line arguments, which are not used
	 */
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
							"job_skill VARCHAR(50))");

			stmt.executeUpdate(
					"INSERT INTO job_postings " +
							"(job_id, is_open, company_name, job_name, job_location, job_skill) VALUES " +
							"(1, TRUE, 'Apple', 'Software Engineer', 'Cupertino', 'Programming'), " +
							"(2, FALSE, 'Google', 'Data Engineer', 'Sunnyvale', 'SQL'), " +
							"(3, TRUE, 'SJSU', 'Instructor', 'San Jose', 'Teaching'), " +
							"(4, TRUE, 'Meta', 'Data Scientist', 'Menlo Park', 'Python'), " +
							"(5, TRUE, 'Microsoft', 'Software Developer', 'Mountain View', 'Java'), " +
							"(6, FALSE, 'Amazon', 'Business Analyst', 'San Francisco', 'Excel'), " +
							"(7, TRUE, 'NVIDIA', 'Machine Learning Engineer', 'Santa Clara', 'Machine Learning'), " +
							"(8, TRUE, 'Netflix', 'Data Analyst', 'Los Gatos', 'Data Analysis'), " +
							"(9, FALSE, 'Tesla', 'Database Administrator', 'Palo Alto', 'MySQL'), " +
							"(10, TRUE, 'Adobe', 'UX Designer', 'San Jose', 'UI/UX'), " +
							"(11, TRUE, 'Cisco', 'Network Engineer', 'San Jose', 'Networking'), " +
							"(12, FALSE, 'LinkedIn', 'Product Analyst', 'Sunnyvale', 'Analytics'), " +
							"(13, TRUE, 'PayPal', 'Financial Analyst', 'San Jose', 'Finance'), " +
							"(14, TRUE, 'Intuit', 'Software Engineer Intern', 'Mountain View', 'Java'), " +
							"(15, FALSE, 'Salesforce', 'Cloud Engineer', 'San Francisco', 'Cloud Computing')");

			System.out.printf(
					"| %-5s | %-6s | %-20s | %-25s | %-20s | %-15s |%n",
					"ID", "Open", "Company", "Job", "Location", "Skill");

			System.out.println(
					"|-------|--------|----------------------|---------------------------|----------------------|-----------------|");

			ResultSet rs = stmt.executeQuery(
					"SELECT * FROM job_postings");

			while (rs.next()) {
				System.out.printf(
						"| %-5d | %-6b | %-20s | %-25s | %-20s | %-15s |%n",
						rs.getInt("job_id"),
						rs.getBoolean("is_open"),
						rs.getString("company_name"),
						rs.getString("job_name"),
						rs.getString("job_location"),
						rs.getString("job_skill"));
			}

			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
