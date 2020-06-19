package com.revature.readifined.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.Genre;
import com.revature.readifined.services.ResourceServiceImpl;

@Controller
public class ResourceController {
private ResourceServiceImpl resourceServiceImpl;
	
	@Autowired
	public void setLoginService (ResourceServiceImpl resourceServiceImpl)
	{
		this.resourceServiceImpl=resourceServiceImpl;
	}
	@RequestMapping(path = "/genres", method = RequestMethod.GET)
	@ResponseBody
	public List<Genre> getGenres() {
		return resourceServiceImpl.getAllGenres();
	}
	
	@RequestMapping(path = "/books", method = RequestMethod.GET)
	@ResponseBody
	public List<Book> getBooks(@RequestParam(name = "genre", required = true) String genre) {
		return resourceServiceImpl.getAllBooksbyGenre(genre);
	}
}
