package com.revature.readifined.dao;

import com.revature.readifined.domain.BookTags;

public interface BookTagsDAO {

    public BookTags getBookTags(int id);
	
	public BookTags getBookTags(String value,String column);
	
	public void saveBookTags(BookTags bt);
	
	public void updateBookTags(BookTags bt);
	
	public void deleteBookTags(BookTags bt);
}
