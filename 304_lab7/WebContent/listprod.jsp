<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

	<h1>Search for the products you want to buy:</h1>

	<form method="get" action="listprod.jsp">
		<input type="text" name="productName" size="50"> <input
			type="submit" value="Submit"><input type="reset"
			value="Reset"> (Leave blank for all products)
	</form>

	<%
		// Get product name to search for

		String name = request.getParameter("productName");
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ccheung";
		String uid = "ccheung";
		String pw = "22299382";
		
		//Note: Forces loading of SQL Server driver
		try{
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch(java.lang.ClassNotFoundException e){
			out.println("ClassNotFoundException: " +e);
		}

		try {
			Connection con = DriverManager.getConnection(url, uid, pw);  
			// Load driver class
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			if(name == null){
				String all = "SELECT pid, pname, price FROM product";
				PreparedStatement sall = con.prepareStatement(all);
				ResultSet setall = sall.executeQuery();
				out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
				while(setall.next()){
					out.println("<tr><td><a href=\"addcart.jsp?id=" + setall.getInt("pid") + "&name="
							+ URLEncoder.encode(setall.getString("pname"), "Windows-1252") + "&price="
							+ setall.getString("price") + "\">Add to Cart</a></td><td>" + setall.getString("pname")
							+ "</td><td>" + currFormat.format(setall.getDouble("price")) + "</td></tr>");
				}
				out.println("</table>");
			}
			else{
			String sql = "SELECT pid, pname, price FROM product WHERE pname LIKE ? ";
			PreparedStatement s = con.prepareStatement(sql);
			s.setString(1, "%"+name+"%");
			ResultSet set = s.executeQuery();
			if (!set.next()) {
				out.println("Invalid keyword!");
			} else {
				out.println("Products containing '" + name + "'");
				out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
				while (set.next()) {
					out.println("<tr><td><a href=\"addcart.jsp?id=" + set.getInt("pid") + "&name="
							+ URLEncoder.encode(set.getString("pname"), "Windows-1252") + "&price="
							+ set.getString("price") + "\">Add to Cart</a></td><td>" + set.getString("pname")
							+ "</td><td>" + currFormat.format(set.getDouble("price")) + "</td></tr>");
				}
				out.println("<\table>");
			}
			con.close();
		}
		}catch (SQLException ex) {
			out.println("SQLException: " + ex);
		}

		// Variable name now contains the search string the user entered
		// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

		// Make the connection

		// Print out the ResultSet

		// For each product create a link of the form
		// addcart.jsp?id=<productId>&name=<productName>&price=<productPrice>
		// Note: As some product names contain special characters, need to encode URL parameter for product name like this: URLEncoder.encode(productName, "Windows-1252")
		// Close connection

		// Useful code for formatting currency values:
		// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		// out.println(currFormat.format(5.0);	// Prints $5.00
	%>

</body>
</html>