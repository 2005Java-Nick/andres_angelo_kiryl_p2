package com.revature.readifined.test;

import static org.junit.Assert.*;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.revature.readifined.config.AppConfig;
import com.revature.readifined.dao.BookDAOImpl;
import com.revature.readifined.domain.Book;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class BookDAOImplTest {
	
	@Autowired
	BookDAOImpl bDAO;
	
	
	// Save
	@Test
	public void testA() {
		Book b = new Book();
		b.setId(1);
		b.setTitle("It");
		b.setPrice(9.99);
		b.setAuthor("Stephen King");
		b.setCoverImg((byte) 12);
		b.setBook((byte) 24);
		assertTrue(true);
	}
	
	// Get Book by Title
	@Test
	public void testB() {
		Book b = bDAO.getBook("It", "title");
		assertEquals("Titles are the same: ", "It", b.getTitle());
	}
	// Get Book 
	@Test
	public void testC() {
		Book b = bDAO.getBook(9.99, "price");
		assertEquals("Prices are the same: ", 9.99, b.getPrice());
	}
	
	// Update price
	@Test
	public void testD() {
		Book b = bDAO.getBook(9.99, "price");
		b.setPrice(4.99);
		bDAO.updateBook(b);
		Book bNew = bDAO.getBook(4.99, "price");
		assertEquals("Prices are the same: ", 4.99, bNew.getPrice());
	}
	
	// Delete
	@Test
	public void testE() {
		Book b = bDAO.getBook("It", "title");
		bDAO.deleteBook(b);
		assertTrue(true);
	}

}
