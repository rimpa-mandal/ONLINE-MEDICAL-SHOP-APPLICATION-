<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.shop.DBConnection"%>
<!DOCTYPE html>
<html>
<head>
    <title>Medicine Shop</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(to right, #e3f2fd, #ffffff);
        margin: 0;
        padding: 20px;
    }

    h1 {
        text-align: center;
        color: #0d47a1;
        margin-bottom: 20px;
    }

    .container {
        width: 60%;
        margin: auto;
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }

    label {
        font-weight: bold;
        display: inline-block;
        width: 150px;
        margin-top: 10px;
    }

    input, select {
        padding: 8px;
        width: 200px;
        border-radius: 5px;
        border: 1px solid #ccc;
        margin-top: 10px;
    }

    input:focus, select:focus {
        border-color: #2196f3;
        outline: none;
    }

    button {
        margin-top: 15px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        background: #2196f3;
        color: white;
        cursor: pointer;
        font-size: 14px;
        transition: 0.3s;
    }

    button:hover {
        background: #0d47a1;
    }

    table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
        background: white;
    }

    th {
        background: #2196f3;
        color: white;
        padding: 10px;
    }

    td {
        padding: 10px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    tr:hover {
        background-color: #f1f1f1;
    }

    .total-box {
        margin-top: 15px;
        font-size: 18px;
        font-weight: bold;
        color: #2e7d32;
    }

</style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    let totalAmount = 0;
        function fetchMedicineDetails() {
            var medicineName = $('#medicineSelect').val();
            $.get('medicine?medicineName=' + medicineName, function(data) {
                if (data.error) {
                    alert(data.error);
                } else {
                    $('#price').val(data.price);
                    $('#stock').val(data.stock);
                    $('#expiryDate').val(data.expiryDate);
                }
            }, 'json');
        }

        function addToTable() {
        	var medicineName = $('#medicineSelect').val();
            var quantity = parseInt($('#quantity').val(), 10); // Convert to integer
            var price = parseFloat($('#price').val()); // Convert to float
            var amount = (price * quantity).toFixed(2);
            var stock = parseInt($('#stock').val(), 10); // Convert to integer
            
            if (quantity > stock) {
                alert("Not enough stock available!");
                return;
            }

            $('#medicineTable tbody').append('<tr><td>' + medicineName + '</td><td>' + quantity + '</td><td>' + amount + '</td></tr>');

            $.post('medicine', { medicineName: medicineName, quantity: quantity }, function() {
                $('#stock').val(stock - quantity);//Stock Updation
                totalAmount = parseFloat($('#totalAmount').val());
                totalAmount += parseFloat(amount);
                $('#totalAmount').val(totalAmount.toFixed(2)); // Ensure total amount is formatted correctly
            });
        }
        
        function submitData() {  
            const medicineTable = document.getElementById("medicineTable");  
            const medicineData = [];  

            for (let i = 1; i < medicineTable.rows.length; i++) { // Start from 1 to skip the header row  
                const row = medicineTable.rows[i];  
            	
                medicineData.push({  
                    name: row.cells[0].innerHTML,  
                    units: row.cells[1].innerHTML,  
                    amount: row.cells[2].innerHTML  
                });  
            }  
            sessionStorage.setItem("medicineData", JSON.stringify(medicineData));  
            window.location.href = "DisplayMedicine.jsp"; // Redirect to the new page  
        }
        
        
        
        
    </script>
</head>
<body>
    <h1>Medicine Shop</h1>
    <div class="container">
    <label >Select Medicine:</label>
    <select id="medicineSelect" onchange="fetchMedicineDetails()">
        <option value="">Select</option>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT medicine_name FROM medicines");
                while (rs.next()) {
                    String name = rs.getString("medicine_name");
        %>
                    <option value="<%= name %>"><%= name %></option>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
    </select>

    <br>
    <label for="price">Price:</label>
    <input type="text" id="price" readonly>
    <br>
    <label for="stock">Stock:</label>
    <input type="number" id="stock" readonly>
    <br>
    <label for="expiryDate">Expiry Date:</label>
    <input type="text" id="expiryDate" readonly>
    <br>
    <label for="quantity">Quantity:</label>
    <input type="number" id="quantity" onkeydown="if(event.key === 'Enter'){ addToTable(); }">
    <br>
    
    <label for="totalAmount">Total Amount:</label>  
    <input type="text" id="totalAmount" value="0" readonly><br><br> 
    
    <button onclick="addToTable()">Add to Table</button>
	<button type="button" onclick="submitData()">Submit</button>
    <h2>Purchase Summary</h2>
    <table id="medicineTable" border="1">
        <thead>
            <tr>
                <th>Medicine Name</th>
                <th>Quantity</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    </div>
</body>
</html>