package edu.pitt.is1017.spaceinvaders;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
public class ScoreTracker {
	private User user;
	private int currentScore;
	private int highestScore;
	private String gameID;
	private DbUtilities db;
	public ScoreTracker(User user){
		this.setUser(user);
		this.setCurrentScore(currentScore);
		UUID uuid = UUID.randomUUID();
		this.setGameID(uuid.toString());
		
		this.db = new DbUtilities();
		String sql = "SELECT MAX(scoreValue) as highestScore from finalscores where fk_userID ="+this.user.getUserID();
		try{
			ResultSet rs = db.getResultSet(sql);
			if(rs.next()){
				System.out.println(rs.getInt("highestScore"));
				this.setHighestScore(rs.getInt("highestScore"));
				System.out.println("your highest score "+this.getHighestScore());
			}
		}catch(Exception e){
			
		}finally{
			//Would slow down the program if I had to estabilsh a connection everytime there's a shot
//			db.closeConnection();
		}
		
	}
	
	public void recordScore(int point){
		this.setCurrentScore(this.getCurrentScore()+point);
//		DbUtilities db = new DbUtilities();
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		String sql = "INSERT into runningscores(gameID, scoreType, scoreValue, fk_userID,dateTimeEntered) ";
		
		sql += "VALUES ('"+this.getGameID()+"', 1,'"+point+"','"+this.getUser().getUserID()+"','"+dateFormat.format(date)+"')";
		System.out.println(sql);
		try{
			db.executeQuery(sql);
		}catch(Exception e){
			System.out.println(e);
		}
	}
	public void recordFinalScore(){
//		DbUtilities db = new DbUtilities();
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		if(this.getCurrentScore()>this.getHighestScore()){
			this.setHighestScore(this.getCurrentScore());
		}
		String sql = "INSERT into finalscores(gameID, scoreValue, fk_userID,dateTimeEntered) ";
		sql += "VALUES ('"+this.getGameID()+"', '"+this.getCurrentScore()+"','"+this.getUser().getUserID()+"','"+dateFormat.format(date)+"')";
		System.out.println(sql);
		try{
			db.executeQuery(sql);
		}catch(Exception e){
			System.out.println(e);
		}
	}
	
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public int getCurrentScore() {
		return currentScore;
	}
	public void setCurrentScore(int currentScore) {
		this.currentScore = currentScore;
	}
	public int getHighestScore() {
		return highestScore;
	}
	public void setHighestScore(int highestScore) {
		this.highestScore = highestScore;
	}
	public String getGameID() {
		return gameID;
	}
	public void setGameID(String gameID) {
		this.gameID = gameID;
	}

}
