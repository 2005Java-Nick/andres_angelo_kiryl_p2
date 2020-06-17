package com.revature.readifined.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookGenreDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.domain.Genre;


@Service
public class ResourceServiceImpl implements ResourceService {

	BookGenreDAOImpl bookGenreDAOImpl;
	GenreDAOImpl genreDAOImpl;
	BookDAOImpl booKDAOImpl;	
	
	@Autowired
	public void setBookGenreDAOImpl(BookGenreDAOImpl bookGenreDAOImpl) {
		this.bookGenreDAOImpl = bookGenreDAOImpl;
	}
	@Autowired
	public void setGenreDAOImpl(GenreDAOImpl genreDAOImpl) {
		this.genreDAOImpl = genreDAOImpl;
	}
	@Autowired
	public void setBooKDAOImpl(BookDAOImpl booKDAOImpl) {
		this.booKDAOImpl = booKDAOImpl;
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
	public void getAllBooks() {
		// TODO Auto-generated method stub
		
	}

}
