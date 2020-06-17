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
import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.dao.BookGenreDAOImpl;
import com.revature.readifined.dao.BookTagsDAOImpl;
import com.revature.readifined.dao.GenreDAOImpl;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.TagDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.BookGenre;
import com.revature.readifined.domain.BookTags;
import com.revature.readifined.domain.Genre;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Tag;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class BookTagsDAOImplTest {

	@Autowired
	BookTagsDAOImpl btDAO;
	@Autowired
	BookDAOImpl bDAO;
	@Autowired
	TagDAOImpl tDAO;
	@Autowired
	PersonDAOImpl pDAO;
	
	Tag t,t1;
	Book b;
	Person p;
	
	public void setup()
	{
		t=new Tag();
		t.setTagName("Test");
		t1=new Tag();
		t1.setTagName("Test1");
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
		b.setCoverImg(text);
		b.setBook(text);
		tDAO.saveTag(t);
		tDAO.saveTag(t1);
		bDAO.saveBook(b);
		t=tDAO.getTag(t.getTagName(), "tagName");
		t1=tDAO.getTag(t1.getTagName(),"tagName");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	public void setupNoSave()
	{
		t=new Tag();
		t.setTagName("Test");
		t1=new Tag();
		t1.setTagName("Test1");
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
		b.setCoverImg(text);
		b.setBook(text);
		t=tDAO.getTag(t.getTagName(), "tagName");
		t1=tDAO.getTag(t1.getTagName(),"tagName");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	// Save
	@Test
	public void testA() {
		setup();
		BookTags bt=new BookTags();
		bt.setBookId(b.getId());
		bt.setTagId(t.getId());
		btDAO.saveBookTags(bt);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		setupNoSave();
		BookTags a = btDAO.getBookTags(t.getId(), "tagId");
		assertEquals("Tag names should be the same ",t.getId(),a.getTagId());
	}
	// Get by id
	@Test
	public void testC() {
		setupNoSave();
		BookTags a = btDAO.getBookTags(t.getId(), "tagId");
		BookTags b = btDAO.getBookTags(a.getId());
		assertEquals("Tag id should be the same",a.getTagId(),b.getTagId());
	}
	
	// Update
	@Test
	public void testD() {
		setupNoSave();
		BookTags a = btDAO.getBookTags(t.getId(), "tagId");
		a.setTagId(t1.getId());
		btDAO.updateBookTags(a);
		BookTags b = btDAO.getBookTags(t1.getId(), "tagId");
		assertEquals("Genres id should be the same",t1.getId(),b.getTagId());
	}
	
	// Delete
	@Test
	public void testE() {
		setupNoSave();
		BookTags a = btDAO.getBookTags(t1.getId(), "tagId");
		btDAO.deleteBookTags(a);
		tDAO.deleteTag(t);
		tDAO.deleteTag(t1);
		bDAO.deleteBook(b);
		pDAO.deletePerson(p);
		assertTrue(true);
	}

}
