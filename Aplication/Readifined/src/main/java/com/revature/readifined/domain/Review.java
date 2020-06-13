package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


public class Review implements Serializable{

	private static final long serialVersionUID = -2139217610400596091L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	int id;
	@Column(name = "review_body")
	String reviewBody;
	@Column(name = "rating")
	int rating;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getReviewBody() {
		return reviewBody;
	}
	public void setReviewBody(String reviewBody) {
		this.reviewBody = reviewBody;
	}
	public int getRating() {
		return rating;
	}
	public void setRating(int rating) {
		this.rating = rating;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		result = prime * result + rating;
		result = prime * result + ((reviewBody == null) ? 0 : reviewBody.hashCode());
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
		Review other = (Review) obj;
		if (id != other.id)
			return false;
		if (rating != other.rating)
			return false;
		if (reviewBody == null) {
			if (other.reviewBody != null)
				return false;
		} else if (!reviewBody.equals(other.reviewBody))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Review [id=" + id + ", reviewBody=" + reviewBody + ", rating=" + rating + "]";
	}
	
}
