package com.revature.readifined.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.hamcrest.core.IsInstanceOf;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.revature.readifined.config.AppConfig;
import com.revature.readifined.dao.AddressDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.Genre;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class GenreDAOImplTest {
	
	@Autowired
	GenreDAOImpl gDAO;
	
	// Save
	@Test
	public void testA() {
		Genre g =new Genre();
		g.setGenre("Test");
		gDAO.saveGenre(g);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		Genre a=gDAO.getGenre("Test", "genre");
		assertEquals("Genres should be the same","Test",a.getGenre());
	}
	// Get by id
	@Test
	public void testC() {
		Genre a=gDAO.getGenre("Test", "genre");
		Genre b=gDAO.getGenre(a.getId());
		assertEquals("Genres should be the same",a.getGenre(),b.getGenre());
	}
	
	// Get all genres
	@Test
	public void testD() {
		List<Genre> list=gDAO.getAllGenres();
		if(list.get(0) instanceof Genre)
		{
			assertTrue(true);
		}
	}
	
	// Update
	@Test
	public void testE() {
		Genre a=gDAO.getGenre("Test", "genre");
		a.setGenre("Test1");;
		gDAO.updateGenre(a);
		assertEquals("Genres should be the same","Test1",a.getGenre());
	}
	
	// Delete
	@Test
	public void testF() {
		Genre a=gDAO.getGenre("Test1", "genre");
		gDAO.deleteGenre(a);
		assertTrue(true);
	}
	
	@Test
	public void testG() {
		List<Genre>list = gDAO.getAllGenres();
		if(list!=null)
			assertEquals("Should return Genres",true,list.get(0) instanceof Genre);
		else
			assertTrue(true);
	}
	
}
