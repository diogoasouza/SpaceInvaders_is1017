package edu.pitt.is1017.spaceinvaders;

import java.sql.ResultSet;

import javax.swing.JOptionPane;

public class User {
	private int userID;
	private String lastName;
	private String firstName;
	private String email;
	private String password;
	private boolean loggedIn;
	
	/**
	 * Retrieves data from the database using about an user and set the appropriate class properties.
	 * @param userID - ID of the user you want to find information about 
	 */
	public User(int userID) {
		DbUtilities db = new DbUtilities();
		String sql = "select * from users where userID=" + userID;
		try{
			ResultSet rs = db.getResultSet(sql);
			if(rs.next()){
                                this.userID = rs.getInt("userID");
				this.setEmail(rs.getString("email"));
				this.setFirstName(rs.getString("firstName"));
				this.setLastName(rs.getString("lastName"));
				this.setPassword(rs.getString("password"));
				
				System.out.print(rs.getInt("userID") + "\t");
				System.out.print(rs.getString("lastName") + "\t");
				System.out.print(rs.getString("firstName") + "\t");
				System.out.print(rs.getString("email") + "\t");
				System.out.print(rs.getString("password") + "\t");	
			}else{
				JOptionPane.showMessageDialog(null, "Invalid user ID.","Error", JOptionPane.ERROR_MESSAGE);
			}
			
			
		}catch(Exception e){
			
		}finally{
			db.closeConnection();
		}
	}
	/**
	 * Check the database for an user with the combination email,password.
	 * If the user exists it sets the appropriate class properties changes the status to logged in,
	 * if user does not exists it sets the status to logged out and sends an error message.
	 * @param email - email of the user
	 * @param password - password of the user
	 */
	public User(String email, String password){
		DbUtilities db = new DbUtilities();
		String sql = "select * from users where email='"+email+"' and password=MD5('"+password+"')";
		System.out.println(sql);
		try{
			ResultSet rs = db.getResultSet(sql);
			if(rs.next()){
				this.userID = rs.getInt("userID");
				this.setEmail(rs.getString("email"));
				this.setFirstName(rs.getString("firstName"));
				this.setLastName(rs.getString("lastName"));
				this.setPassword(rs.getString("password"));
				this.setLoggedIn(true);
				System.out.print(rs.getInt("userID") + "\t");
				System.out.print(rs.getString("lastName") + "\t");
				System.out.print(rs.getString("firstName") + "\t");
				System.out.print(rs.getString("email") + "\t");
				System.out.print(rs.getString("password") + "\t");
				System.out.println();
				
				//JOptionPane.showMessageDialog(null, "Login successful!","login successful",JOptionPane.INFORMATION_MESSAGE);
			}else{
				this.setLoggedIn(false);
				JOptionPane.showMessageDialog(null, "Login failed.","Login error", JOptionPane.ERROR_MESSAGE);
			}
			
		}catch(Exception e){
			System.out.println(e);
			
		}finally{
			db.closeConnection();
		}
	}
	/**
	 * Creates a new user entry on the database.
	 * @param lastName - last name of the user
	 * @param firstName - first name of the user
	 * @param email - email of the user
	 * @param password - password of the user
	 */
	public User(String lastName, String firstName, String email, String password){
		DbUtilities db = new DbUtilities();
		String sql = "INSERT into users(lastName, firstName, email, password) ";
		sql += "VALUES ('"+lastName+"', '"+firstName+"','"+email+"',MD5('"+password+"'))";
		System.out.print(sql);
		this.setEmail(email);
		this.setFirstName(firstName);
		this.setLastName(lastName);
		this.setPassword(password);
		this.setLoggedIn(false);
		try{
			db.executeQuery(sql);
		}catch(Exception e){
			System.out.println(e);
		}
		
	}

    public void setUserID(int userID) {
        this.userID = userID;
    }
	/**
	 * Update the user entry on the database using the current class properties.
	 */
	public void saveUserInfo(){
		DbUtilities db = new DbUtilities();
		String sql = "UPDATE users SET firstName='"+this.getFirstName()+"', lastName='"+this.getLastName()+"', email='"+this.getEmail()+"' , password=MD5('"+this.getPassword()+"')";
		sql += " WHERE userID='"+this.getUserID()+"'";
		db.executeQuery(sql);
	}
	
	public int getUserID() {
		return userID;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isLoggedIn() {
		return loggedIn;
	}

	public void setLoggedIn(boolean loggedIn) {
		this.loggedIn = loggedIn;
	}

	
}
