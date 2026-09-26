package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Company;
import com.placement.util.DBConnection;

public class CompanyDAO {

    public boolean addCompany(Company company) {
        String sql = "INSERT INTO companies (name, sector, hr_name, hr_email, hr_phone) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, company.getName());
            ps.setString(2, company.getSector());
            ps.setString(3, company.getHrName());
            ps.setString(4, company.getHrEmail());
            ps.setString(5, company.getHrPhone());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Company> getAllCompanies() {
        List<Company> companies = new ArrayList<>();
        String sql = "SELECT * FROM companies ORDER BY company_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                companies.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return companies;
    }

    public Company getCompanyById(int companyId) {
        String sql = "SELECT * FROM companies WHERE company_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCompany(Company company) {
        String sql = "UPDATE companies SET name = ?, sector = ?, hr_name = ?, "
                + "hr_email = ?, hr_phone = ? WHERE company_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, company.getName());
            ps.setString(2, company.getSector());
            ps.setString(3, company.getHrName());
            ps.setString(4, company.getHrEmail());
            ps.setString(5, company.getHrPhone());
            ps.setInt(6, company.getCompanyId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCompany(int companyId) {
        String sql = "DELETE FROM companies WHERE company_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, companyId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Company map(ResultSet rs) throws Exception {
        Company company = new Company();
        company.setCompanyId(rs.getInt("company_id"));
        company.setName(rs.getString("name"));
        company.setSector(rs.getString("sector"));
        company.setHrName(rs.getString("hr_name"));
        company.setHrEmail(rs.getString("hr_email"));
        company.setHrPhone(rs.getString("hr_phone"));
        return company;
    }
}
