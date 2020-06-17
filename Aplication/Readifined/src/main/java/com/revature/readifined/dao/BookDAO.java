package com.revature.readifined.dao;

import com.revature.readifined.domain.Book;

public interface BookDAO {
	
	public Book getBook(int id);
	
	public Book getBook(String value,String column);
	
	public void saveBook(Book b);
	
	public void updateBook(Book b);
	
	public void deleteBook(Book b);

}
