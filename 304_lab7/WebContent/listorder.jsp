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
String uid = request.getParameter("uid");
String password = request.getParameter("password");
String url = "cosc304.ok.ubc.ca/srv/www/vhosts/ubc.ca/ok/cosc304/html.ssl";
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
	
	String s = "SELECT coid, customerorder.uid, user.fname, user.lname FROM customerorder,user WHERE user.uid = customerorder.uid AND customerorder.uid = ? AND password = ?";
	PreparedStatement st = con.prepareStatement(s);
	st.setString(1, uid);
	st.setString(2, password);
	try{ResultSet result = st.executeQuery();}
	catch(SQLException e){out.println("Incorrect user id or user password!");}
	
	
	String Total = "SELECT customerorder.pid, product.pname, customerorder.price, hasordered.quantity, SUM(hasordered.quantity * customerorder.price) as totalAmount FROM customerorder, hasordered, product WHERE customerorder.coid = hasordered.coid AND hasordered.pid = product.pid AND coid = ? GROUP BY coid";
	PreparedStatement pre = con.prepareStatement(Total);
	pre.setInt(1, result.getInt("coid"));
	ResultSet totalres = pre.executeQuery();
	
	
	out.println("<h1>Your Order</h1>");
	while(result.next()){
	out.println("<table border=\"1\">");
	out.println("<tr><th>Order Id</th><th>Customer Id</th><th>Customer Name</th></tr>");
	out.println("<tr><td>"+ result.getInt("coid") + "</td><td>"+ result.getInt("uid") +"</td><td>"+ result.getString("fname")+ " " + result.getString("lname")+"</td></tr>");
	out.println("<tr align=\"right\"><td colspan=\"4\"><table border=\"1\">");
	out.println("<th>Product Id</th> <th>Quantity</th> <th>Price</th></tr>");
	while(totalres.next()){
	out.println("<tr><td>"+ totalres.getInt("pid") +"</td><td>"+ totalres.getInt("quantity")+"</td><td>"+currFormat.format(totalres.getDouble("price"))+"</td></tr>");
	}
	out.println("<tr><td>Total Amount</td> <td>" + totalres.getDouble("totalAmount")+ "</td>");
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

