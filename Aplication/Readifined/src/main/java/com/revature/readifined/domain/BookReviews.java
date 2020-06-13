package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "readifined.book_reviews")
public class BookReviews implements Serializable{

	private static final long serialVersionUID = -4505674803555240747L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	int id;
	@Column(name = "review_id")
	int reviewId;
	@Column(name = "book_id")
	int bookId;
	@Column(name = "reviewer_id")
	int reviewerId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getReviewId() {
		return reviewId;
	}
	public void setReviewId(int reviewId) {
		this.reviewId = reviewId;
	}
	public int getBookId() {
		return bookId;
	}
	public void setBookId(int bookId) {
		this.bookId = bookId;
	}
	public int getReviewerId() {
		return reviewerId;
	}
	public void setReviewerId(int reviewerId) {
		this.reviewerId = reviewerId;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + bookId;
		result = prime * result + id;
		result = prime * result + reviewId;
		result = prime * result + reviewerId;
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
		BookReviews other = (BookReviews) obj;
		if (bookId != other.bookId)
			return false;
		if (id != other.id)
			return false;
		if (reviewId != other.reviewId)
			return false;
		if (reviewerId != other.reviewerId)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "BookReviews [id=" + id + ", reviewId=" + reviewId + ", bookId=" + bookId + ", reviewerId=" + reviewerId
				+ "]";
	}
}