package com.revature.readifined.services;

public interface ReviewService {

		public String insertReview(int bookId, String token, String review, int rating);
}
