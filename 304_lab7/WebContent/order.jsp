<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

	<%
		// Get customer id
		String custId = request.getParameter("customerId");
		@SuppressWarnings({ "unchecked" })
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
				.getAttribute("productList");

		// Determine if valid customer id was entered
		// Determine if there are products in the shopping cart
		// If either are not true, display an error message
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ccheung";
		String uid = "ccheung";
		String pw = "22299382";
		// Make connection
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		try {
			Connection con = DriverManager.getConnection(url, uid, pw); // Load driver class
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			String sql = "SELECT customerId, cname FROM Customer WHERE customerId = ?";
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, custId);
			ResultSet set = pstmt.executeQuery();
			if (!set.next()) {
				out.println("Invalid customer ID");
			} else {
		
				String oid = "INSERT INTO Orders (customerId, totalAmount) Values (?,?) ";
				PreparedStatement updateOrder = con.prepareStatement(oid, Statement.RETURN_GENERATED_KEYS);
				
				updateOrder.setString(1,custId);
				updateOrder.setInt(2,0);
				updateOrder.executeUpdate();
				ResultSet keys = updateOrder.getGeneratedKeys();
				keys.next();
				int orderId = keys.getInt(1);
				String buy = "INSERT INTO OrderedProduct VALUES (?, ?,?,?)";
				PreparedStatement bought = con.prepareStatement(buy);
				bought.setInt(1, orderId);
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext())
				{ 
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					String productId = (String) product.get(0);
				String price = (String) product.get(2);
					double pr = Double.parseDouble(price);
					int qty = ( (Integer)product.get(3)).intValue();
				bought.setString(2, productId);
				bought.setDouble(3,pr);
				bought.setInt(4, qty);
				bought.executeUpdate();
				String updatestmt = "UPDATE Orders SET totalAmount = totalAmount + ?";
				PreparedStatement updates = con.prepareStatement(updatestmt);
				updates.setDouble(1, pr);
				updates.executeUpdate();
				}
				String res = "SELECT OrderedProduct.productId as pid, Product.productName, OrderedProduct.quantity, OrderedProduct.price, OrderedProduct.price * quantity AS subtotal FROM Product ,OrderedProduct WHERE Product.productId = OrderedProduct.productId AND orderId = ?";
				PreparedStatement result = con.prepareStatement(res);
				result.setInt(1,orderId);
				ResultSet resultt = result.executeQuery();
				out.println("<h1>Your Order Summary</h1>");
				out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
				while(resultt.next()){
				out.println("<tr><td>"+resultt.getInt("pid")+"</td><td>"+resultt.getString("productName")+"</td><td align=\"center\">"+resultt.getInt("quantity")+"</td><td align=\"right\">"+currFormat.format(resultt.getDouble("price"))+"</td><td align=\"right\">"+resultt.getDouble("subtotal")+"</td></tr></tr>");
				}
				String j = "SELECT orderId, Orders.customerId, cname, totalAmount FROM Customer, Orders WHERE Customer.customerId = Orders.customerId AND orderId = ?";
				PreparedStatement js = con.prepareStatement(j);
				js.setInt(1,orderId);
				ResultSet jss = js.executeQuery();
				jss.next();
				out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td><td aling=\"right\">"+jss.getDouble("totalAmount")+"</td></tr>");
				out.println("</table>");
				out.println("<h1>Order completed.  Will be shipped soon...</h1>");
				out.println("<h1>Your order reference number is: "+jss.getInt("orderId")+"</h1>");
				out.println("<h1>Shipping to customer: "+ jss.getInt("customerId")+" Name: "+ jss.getString("cname")+"</h1>");
				
				con.close();
			}
		} catch (SQLException e) {
			out.println("SQLException: " + e);
		}
		// Save order information to database

		/*
		// Use retrieval of auto-generated keys.
		PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		/*
		
		// Insert each item into OrderedProduct table using OrderId from previous INSERT
		
		// Update total amount for order record
		
		// Here is the code to traverse through a HashMap
		// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
		
		/*
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
		String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
		...
		}
		*/

		// Print out order summary
	%>
</BODY>
</HTML>

