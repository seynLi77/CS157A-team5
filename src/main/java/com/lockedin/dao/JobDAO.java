package com.lockedin.dao;

/**
 * Provides data-access operations for job postings.
 *
 * @author Jumana
 */
public class JobDAO {

    /**
     * Temporarily returns a hardcoded number of open jobs
     * while servlet/JSP integration is being tested.
     */
    public int getOpenJobCount() {
        return 10;
    }
}
