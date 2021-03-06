package com.revature.readifined.dao;

import java.util.List;

import com.revature.readifined.domain.BookGenre;

public interface BookGenreDAO {

    public BookGenre getBookGenre(int id);
	
	public BookGenre getBookGenre(int value,String column);
	
	public List<BookGenre> getBooksGenres(int value,String column);
	
	public void saveBookGenre(BookGenre bg);
	
	public void updateBookGenre(BookGenre bg);
	
	public void deleteBookGenre(BookGenre bg);
}
