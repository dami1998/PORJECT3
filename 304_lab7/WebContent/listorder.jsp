<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ccheung";
		String uid = "ccheung";
		String pw = "22299382";
		
		System.out.println("Connecting to database.");
	try{Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");}
	catch(java.lang.ClassNotFoundException e){
		out.println("ClassNotFoundException: " +e);
	}

try{
	Connection con = DriverManager.getConnection(url, uid, pw);
	// Load driver class
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	Statement stmt = con.createStatement();
	ResultSet s = stmt.executeQuery("SELECT orderId, Orders.customerId, cname, totalAmount FROM Orders, Customer WHERE Customer.customerId = Orders.customerId ORDER BY orderId ASC");
	String sql = "SELECT * FROM OrderedProduct WHERE orderId = ?";
	
	
	while(s.next()){
		PreparedStatement stmt2 = con.prepareStatement(sql);
		stmt2.setString(1, s.getString("orderId"));
		ResultSet rst = stmt2.executeQuery();
	out.println("<table border=\"1\">");
	out.println("<tr><th>Order Id</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	out.println("<tr><td>"+ s.getInt("orderId") +"</td><td>"+ s.getInt("customerId") +"</td><td>"+ s.getString("cname") +"</td><td>"+currFormat.format(s.getDouble("totalAmount"))+"</td></tr>");
	out.println("<tr align=\"right\"><td colspan=\"4\"><table border=\"1\">");
	out.println("<th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>");
	while(rst.next()){
	out.println("<tr><td>"+ rst.getInt("productId") +"</td><td>"+rst.getInt("quantity")+"</td><td>"+currFormat.format(rst.getDouble("price"))+"</td></tr>");
	}
	out.println("</table></td></tr>");	
}
	con.close();
	}
catch (SQLException e)
{
	out.println("SQLException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order headers

// For each order in the ResultSet

	// Print out the order header information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection


%>

</body>
</html>

