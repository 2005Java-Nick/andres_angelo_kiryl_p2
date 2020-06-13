package com.revature.readifined.dao;

import com.revature.readifined.domain.BookGenre;

public interface BookGenreDAO {

    public BookGenre getBookGenre(int id);
	
	public BookGenre getBookGenre(String value,String column);
	
	public void saveBookGenre(BookGenre bg);
	
	public void updateBookGenre(BookGenre bg);
	
	public void deleteBookGenre(BookGenre bg);
}
