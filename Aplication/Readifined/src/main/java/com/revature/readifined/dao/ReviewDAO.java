package com.revature.readifined.dao;

import com.revature.readifined.domain.Review;

public interface ReviewDAO {

    public Review getReview(int id);
	
	public Review getReview(String value,String column);
	
	public Review getReview(int value, String column);
	
	public void saveReview(Review r);
	
	public void updateReview(Review r);
	
	public void deleteReview(Review r);

}

