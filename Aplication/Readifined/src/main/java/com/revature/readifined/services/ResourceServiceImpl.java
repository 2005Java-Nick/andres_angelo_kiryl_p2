package com.revature.readifined.services;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookGenreDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.BookGenre;
import com.revature.readifined.domain.Genre;


@Service
public class ResourceServiceImpl implements ResourceService {

	BookGenreDAOImpl bookGenreDAOImpl;
	GenreDAOImpl genreDAOImpl;
	BookDAOImpl bookDAOImpl;	
	
	@Autowired
	public void setBookGenreDAOImpl(BookGenreDAOImpl bookGenreDAOImpl) {
		this.bookGenreDAOImpl = bookGenreDAOImpl;
	}
	@Autowired
	public void setGenreDAOImpl(GenreDAOImpl genreDAOImpl) {
		this.genreDAOImpl = genreDAOImpl;
	}
	@Autowired
	public void setBookDAOImpl(BookDAOImpl booKDAOImpl) {
		this.bookDAOImpl = booKDAOImpl;
	}

	@Override
	public List<Genre> getAllGenres() {
		return genreDAOImpl.getAllGenres();
	}

	@Override	
	public void getComments() {
		// TODO Auto-generated method stub
		
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
