package com.revature.readifined.domain;

public class Comment {
	
	int reviewer;
	int rating;
	String username;
	String text;
	
	public int getReviewer() {
		return reviewer;
	}
	public void setReviewer(int reviewer) {
		this.reviewer = reviewer;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + rating;
		result = prime * result + reviewer;
		result = prime * result + ((text == null) ? 0 : text.hashCode());
		result = prime * result + ((username == null) ? 0 : username.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Comment other = (Comment) obj;
		if (rating != other.rating)
			return false;
		if (reviewer != other.reviewer)
			return false;
		if (text == null) {
			if (other.text != null)
				return false;
		} else if (!text.equals(other.text))
			return false;
		if (username == null) {
			if (other.username != null)
				return false;
		} else if (!username.equals(other.username))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Comment [reviewer=" + reviewer + ", rating=" + rating + ", username=" + username + ", text=" + text
				+ "]";
	}
	
}
