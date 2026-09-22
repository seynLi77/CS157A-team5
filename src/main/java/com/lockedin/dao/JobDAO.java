package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Provides data-access operations for job postings.
 *
 * @author Jumana
 */
public class JobDAO {

	/**
	 * Returns the number of currently open job postings.
	 *
	 * @return number of open jobs
	 * @throws SQLException if the database query fails
	 */
	public int getOpenJobCount() throws SQLException {

		String sql = "SELECT COUNT(*) " +
				"FROM job_postings " +
				"WHERE is_open = TRUE";

		try (
				Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql);
				ResultSet resultSet = statement.executeQuery()) {

			if (resultSet.next()) {
				return resultSet.getInt(1);
			}

			return 0;
		}
	}
}
