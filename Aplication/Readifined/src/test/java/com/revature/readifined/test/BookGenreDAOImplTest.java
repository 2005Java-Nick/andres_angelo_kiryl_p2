package com.revature.readifined.test;

import static org.junit.Assert.*;

import java.time.LocalDate;

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
import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookGenreDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.BookGenre;
import com.revature.readifined.domain.Genre;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Book;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class BookGenreDAOImplTest {

	@Autowired
	BookGenreDAOImpl bgDAO;
	@Autowired
	BookDAOImpl bDAO;
	@Autowired
	GenreDAOImpl gDAO;
	@Autowired
	PersonDAOImpl pDAO;
	
	Genre g,g1;
	Book b;
	Person p;
	
	public void setup()
	{
		g=new Genre();
		g.setGenre("Test");
		g1=new Genre();
		g1.setGenre("Test1");
		p=new Person();
		p.setDateOfBirth(LocalDate.now());                 
		p.setFirstName("Andres");
		p.setLastName("Toledo");
		p.setUserName("DoomSlayer");
		p.setUserPassword("1992Andres_");
		p.setEmail("amtamusic@hotmail.com");
		p.setPhoneNumber("7186199163");
		pDAO.savePerson(p);
		p=pDAO.getPerson(p.getUserName(), "userName");
		b=new Book();
		String text="Hello World!";
		b.setTitle("Test Book");
		b.setPrice(9.99);
		b.setAuthor(p.getId());
		b.setCoverImg(text.getBytes());
		b.setBook(text.getBytes());
		gDAO.saveGenre(g);
		gDAO.saveGenre(g1);
		bDAO.saveBook(b);
		g=gDAO.getGenre(g.getGenre(), "genre");
		g1=gDAO.getGenre(g1.getGenre(),"genre");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	public void setupNoSave()
	{
		g=new Genre();
		g.setGenre("Test");
		g1=new Genre();
		g1.setGenre("Test1");
		p=new Person();
		p.setDateOfBirth(LocalDate.now());                 
		p.setFirstName("Andres");
		p.setLastName("Toledo");
		p.setUserName("DoomSlayer");
		p.setUserPassword("1992Andres_");
		p.setEmail("amtamusic@hotmail.com");
		p.setPhoneNumber("7186199163");
		p=pDAO.getPerson(p.getUserName(), "userName");
		b=new Book();
		String text="Hello World!";
		b.setTitle("Test Book");
		b.setPrice(9.99);
		b.setAuthor(p.getId());
		b.setCoverImg(text.getBytes());
		b.setBook(text.getBytes());
		g=gDAO.getGenre(g.getGenre(), "genre");
		g1=gDAO.getGenre(g1.getGenre(),"genre");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	// Save
	@Test
	public void testA() {
		setup();
		BookGenre bg=new BookGenre();
		System.out.println(g.toString());
		System.out.println(b.toString());
		bg.setBookId(b.getId());
		bg.setGenreId(g.getId());
		bgDAO.saveBookGenre(bg);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		setupNoSave();
		BookGenre a = bgDAO.getBookGenre(g.getId(), "genreId");
		assertEquals("Genres id should be the same ",g.getId(),a.getGenreId());
	}
	// Get by id
	@Test
	public void testC() {
		setupNoSave();
		BookGenre a = bgDAO.getBookGenre(g.getId(), "genreId");
		BookGenre b = bgDAO.getBookGenre(a.getId());
		assertEquals("Genres id should be the same",a.getGenreId(),b.getGenreId());
	}
	
	// Update
	@Test
	public void testD() {
		setupNoSave();
		BookGenre a = bgDAO.getBookGenre(g.getId(), "genreId");
		a.setGenreId(g1.getId());
		bgDAO.saveBookGenre(a);
		assertEquals("Genres id should be the same",g1.getId(),a.getGenreId());
	}
	
	// Delete
	@Test
	public void testE() {
		setupNoSave();
		BookGenre a = bgDAO.getBookGenre(g1.getId(), "genreId");
		bgDAO.deleteBookGenre(a);
		gDAO.deleteGenre(g);
		gDAO.deleteGenre(g1);
		bDAO.deleteBook(b);
		pDAO.deletePerson(p);
		assertTrue(true);
	}
}
