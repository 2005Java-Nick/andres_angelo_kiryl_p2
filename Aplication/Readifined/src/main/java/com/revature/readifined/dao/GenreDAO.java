package com.revature.readifined.dao;

import java.util.List;

import com.revature.readifined.domain.Genre;

public interface GenreDAO {

	public Genre getGenre(int id);
	
	public Genre getGenre(String value,String column);
	
	public void saveGenre(Genre g);
	
	public void updateGenre(Genre g);
	
	public void deleteGenre(Genre g);

	public List<Genre> getAllGenres();
	
}
