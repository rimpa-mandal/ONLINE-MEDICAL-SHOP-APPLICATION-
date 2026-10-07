package com.shop;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class MedicineServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String medicineName = request.getParameter("medicineName");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT price, stock, exp_date FROM medicines WHERE medicine_name = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, medicineName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                double price = rs.getDouble("price");
                int stock = rs.getInt("stock");
                String expiryDate = rs.getString("exp_date");
                out.println("{\"price\":" + price + ", \"stock\":" + stock + ", \"expiryDate\":\"" + expiryDate + "\"}");
            } else {
                out.println("{\"error\":\"Medicine not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"error\":\"Database error\"}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String medicineName = request.getParameter("medicineName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE medicines SET stock = stock - ? WHERE medicine_name = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, quantity);
            stmt.setString(2, medicineName);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}