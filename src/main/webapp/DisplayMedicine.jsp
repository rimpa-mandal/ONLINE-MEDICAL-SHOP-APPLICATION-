<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<!DOCTYPE html>  
<html>  
<head>  
    <title>Medicine Purchase Summary</title>  
    <script>  
        function loadMedicineData() {  
            const medicineData = JSON.parse(sessionStorage.getItem("medicineData"));  
            const table = document.getElementById("medicineSummaryTable");  

            if (medicineData) {  
                medicineData.forEach((medicine) => {  
                    const row = table.insertRow();  
                    row.insertCell(0).innerHTML = medicine.name;  
                    row.insertCell(1).innerHTML = medicine.units;  
                    row.insertCell(2).innerHTML = medicine.amount;  
                });  
            }  
            sessionStorage.removeItem("medicineData"); // Clear the session storage after loading  
        }  
        window.onload = loadMedicineData; // Load data when the page is loaded  
    </script>  
</head>  
<body>  
    <h1>Medicine Purchase Summary</h1>  
    <table border="1" id="medicineSummaryTable">  
        <tr>  
            <th>Medicine Name</th>  
            <th>Units</th>  
            <th>Amount</th>  
        </tr>   
    </table>  
    
    
</body>  
</html>  