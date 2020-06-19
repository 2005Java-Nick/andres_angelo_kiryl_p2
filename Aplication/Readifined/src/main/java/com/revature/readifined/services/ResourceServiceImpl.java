package com.revature.readifined.services;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookGenreDAOImpl;
import com.revature.readifined.dao.BookReviewDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.ReviewDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.BookGenre;
import com.revature.readifined.domain.BookReviews;
import com.revature.readifined.domain.Comment;
import com.revature.readifined.domain.Genre;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Review;


@Service
public class ResourceServiceImpl implements ResourceService {

	BookGenreDAOImpl bookGenreDAOImpl;
	BookReviewDAOImpl bookReviewDaoImpl;
	GenreDAOImpl genreDAOImpl;
	BookDAOImpl bookDAOImpl;
	ReviewDAOImpl reviewDAOImpl;
	PersonDAOImpl personDAOImpl;
	
	@Autowired
	public void setBookGenreDAOImpl(BookGenreDAOImpl bookGenreDAOImpl) {
		this.bookGenreDAOImpl = bookGenreDAOImpl;
	}
	@Autowired
	public void setBookReviewDAOImpl(BookReviewDAOImpl bookReviewDaoImpl) {
		this.bookReviewDaoImpl = bookReviewDaoImpl;
	}
	@Autowired
	public void setGenreDAOImpl(GenreDAOImpl genreDAOImpl) {
		this.genreDAOImpl = genreDAOImpl;
	}
	@Autowired
	public void setBookDAOImpl(BookDAOImpl booKDAOImpl) {
		this.bookDAOImpl = booKDAOImpl;
	}
	@Autowired
	public void setReviewDAOImpl(ReviewDAOImpl reviewDAOImpl) {
		this.reviewDAOImpl = reviewDAOImpl;
	}
	@Autowired
	public void setPersonDAOImpl(PersonDAOImpl personDAOImpl) {
		this.personDAOImpl = personDAOImpl;
	}

	@Override
	public List<Genre> getAllGenres() {
		return genreDAOImpl.getAllGenres();
	}

	@Override	
	public List<Comment> getReviews(int bookId) {
		// TODO Auto-generated method stub
		List<BookReviews> reviews= bookReviewDaoImpl.getBookReviews(bookId,"bookId");
		List<Comment> comments = new ArrayList<Comment>();
		for(BookReviews review : reviews)
		{
			Review r = reviewDAOImpl.getReview(review.getReviewId());
			Person p = personDAOImpl.getPerson(review.getReviewerId());
			Comment c = new Comment();
			c.setReviewer(r.getId());
			c.setRating(r.getRating());
			c.setText(r.getReviewBody());
			c.setUsername(p.getUserName());
			comments.add(c);
		}	
		return comments;
	}

	@Override
	public List<Book> getAllBooks() {
		return bookDAOImpl.getAllBooks();
	}

	@Override
	public List<Book> getAllBooksbyGenre(String genre) {
		Genre g = genreDAOImpl.getGenre(genre, "genre");
		List<BookGenre> bgs = bookGenreDAOImpl.getBooksGenres(g.getId(), "genreId");
		List<Book> books = new ArrayList<Book>();
		for(BookGenre bg : bgs)
		{
			books.add(bookDAOImpl.getBook(bg.getBookId()));
		}
		return books;
	}

}
