package com.revature.readifined.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookReviewDAOImpl;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.ReviewDAOImpl;
import com.revature.readifined.domain.BookReviews;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Review;

@Service
public class ReviewServiceImpl implements ReviewService {

	private ReviewDAOImpl reviewDaoImpl;
	private PersonDAOImpl personDaoImpl;
	private BookDAOImpl bookDaoImpl;
	private BookReviewDAOImpl bookReviewDaoImpl;
	
	@Autowired
	public void setReviewDaoImpl(ReviewDAOImpl reviewDaoImpl)
	{
		this.reviewDaoImpl = reviewDaoImpl;
	}
	
	@Autowired
	public void setPersonDaoImpl(PersonDAOImpl personDaoImpl)
	{
		this.personDaoImpl = personDaoImpl;
	}
	
	@Autowired
	public void setBookDaoImpl(BookDAOImpl bookDaoImpl)
	{
		this.bookDaoImpl = bookDaoImpl;
	}
	
	@Autowired
	public void setBookReviewDaoImpl(BookReviewDAOImpl bookReviewDaoImpl)
	{
		this.bookReviewDaoImpl = bookReviewDaoImpl;
	}
	
	public String insertReview(int bookId, String token, String review, int rating)
	{
		try {
			Person p = personDaoImpl.getPerson(token,"token");
			Review r = new Review();
			r.setRating(rating);
			r.setReviewBody(review);
			reviewDaoImpl.saveReview(r);
			r= reviewDaoImpl.getReview(review,"reviewBody");
			BookReviews br = new BookReviews();
			br.setBookId(bookId);
			br.setReviewerId(p.getId());
			br.setReviewId(r.getId());
			bookReviewDaoImpl.saveBookReview(br);
		}catch(Exception e){
			return "Error inserting review";
		}
		return "Review inserted";
	}
	
}
