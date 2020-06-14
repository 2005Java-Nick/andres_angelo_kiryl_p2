package com.revature.readifined.dao;


import com.revature.readifined.domain.BookReviews;

	public interface BookReviewDAO {

	public BookReviews getBookReview(int id);
	
	public BookReviews getBookReview(int value,String column);
	
	public void saveBookReview(BookReviews br);
	
	public void updateBookReview(BookReviews br);
	
	public void deleteBookReview(BookReviews br);
}
