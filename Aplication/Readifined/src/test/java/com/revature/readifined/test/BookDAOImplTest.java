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
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.Person;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class BookDAOImplTest {
	
	@Autowired
	BookDAOImpl bDAO;
	@Autowired
	PersonDAOImpl pDAO;
	
	
	// Save
	@Test
	public void testA() {
		Book b = new Book();
		Person p=new Person();
		p.setDateOfBirth(LocalDate.now());                 
		p.setFirstName("Andres");
		p.setLastName("Toledo");
		p.setUserName("DoomSlayer");
		p.setUserPassword("1992Andres_");
		p.setEmail("amtamusic@hotmail.com1");
		p.setPhoneNumber("7186199163");
		pDAO.savePerson(p);
		p=pDAO.getPerson(p.getUserName(),"userName");
		String text="Hello World!";
		b.setTitle("Test Book");
		b.setPrice(9.99);
		b.setAuthor(p.getId());
		b.setCoverImg(text.getBytes());
		b.setBook(text.getBytes());
		bDAO.saveBook(b);
		assertTrue(true);
	}
	
	// Get Book by Title
	@Test
	public void testB() {
		Book b = bDAO.getBook("Test Book", "title");
		assertEquals("Titles are the same: ", "Test Book", b.getTitle());
	}
	// Get Book 
	@Test
	public void testC() {
		Book b = bDAO.getBook(9.99, "price");
		assertEquals("Prices are the same: ", 9.99, b.getPrice(),0);
	}
	
	// Update price
	@Test
	public void testD() {
		Book b = bDAO.getBook(9.99, "price");
		b.setPrice(4.99);
		bDAO.updateBook(b);
		Book bNew = bDAO.getBook(4.99, "price");
		assertEquals("Prices are the same: ", 4.99, bNew.getPrice(),0);
	}
	
	// Delete
	@Test
	public void testE() {
		Book b = bDAO.getBook("It", "title");
		bDAO.deleteBook(b);
		Person p=new Person();
		p=pDAO.getPerson("DoomSlayer","userName");
		pDAO.deletePerson(p);
		assertTrue(true);
	}

}
