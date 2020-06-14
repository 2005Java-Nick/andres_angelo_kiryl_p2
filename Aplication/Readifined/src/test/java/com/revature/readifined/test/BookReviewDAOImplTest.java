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
import com.revature.readifined.dao.BookReviewDAOImpl;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.ReviewDAOImpl;
import com.revature.readifined.domain.Book;
import com.revature.readifined.domain.BookReviews;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Review;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class BookReviewDAOImplTest {

	@Autowired
	BookReviewDAOImpl brDAO;
	@Autowired
	BookDAOImpl bDAO;
	@Autowired
	ReviewDAOImpl rDAO;
	@Autowired
	PersonDAOImpl pDAO;
	
	Review r,r1;
	Book b;
	Person p;
	
	public void setup()
	{
		r=new Review();
		r.setReviewBody("Test");
		r1=new Review();
		r1.setReviewBody("Test1");
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
		rDAO.saveReview(r);
		rDAO.saveReview(r1);
		bDAO.saveBook(b);
		r=rDAO.getReview(r.getReviewBody(), "reviewBody");
		r1=rDAO.getReview(r1.getReviewBody(),"reviewBody");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	public void setupNoSave()
	{
		r=new Review();
		r.setReviewBody("Test");
		r1=new Review();
		r1.setReviewBody("Test1");
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
		r=rDAO.getReview(r.getReviewBody(), "reviewBody");
		r1=rDAO.getReview(r1.getReviewBody(),"reviewBody");
		b=bDAO.getBook(b.getTitle(), "title");
	}
	
	// Save
	@Test
	public void testA() {
		setup();
		BookReviews br=new BookReviews();
		br.setBookId(b.getId());
		br.setReviewId(r.getId());
		br.setReviewerId(p.getId());
		brDAO.saveBookReview(br);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		setupNoSave();
		BookReviews a = brDAO.getBookReview(r.getId(), "reviewId");
		assertEquals("Review id should be the same ",r.getId(),a.getReviewId());
	}
	// Get by id
	@Test
	public void testC() {
		setupNoSave();
		BookReviews a = brDAO.getBookReview(r.getId(), "reviewId");
		BookReviews b = brDAO.getBookReview(a.getId());
		assertEquals("Book review id should be the same",a.getId(),b.getId());
	}
	
	// Update
	@Test
	public void testD() {
		setupNoSave();
		BookReviews a = brDAO.getBookReview(r.getId(), "reviewId");
		a.setReviewId(r1.getId());
		brDAO.updateBookReview(a);
		BookReviews b = brDAO.getBookReview(r1.getId(), "reviewId");
		assertEquals("Book review id should be the same",r1.getId(),b.getReviewId());
	}
	
	// Delete
	@Test
	public void testE() {
		setupNoSave();
		BookReviews a = brDAO.getBookReview(r1.getId(), "reviewId");
		brDAO.deleteBookReview(a);
		rDAO.deleteReview(r);
		rDAO.deleteReview(r1);
		bDAO.deleteBook(b);
		pDAO.deletePerson(p);
		assertTrue(true);
	}

}
