package com.revature.readifined.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.Genre;

@Service
public interface ResourceService {
	
	public void getComments();
	public List<Genre> getAllGenres();
	public List<Book> getAllBooks();
	public List<Book> getAllBooksbyGenre(String genre);
	
}
