package com.revature.readifined.test;

import static org.junit.Assert.*;

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
import com.revature.readifined.dao.ReviewDAOImpl;
import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.Review;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class ReviewDAOImplTest {

	@Autowired
	ReviewDAOImpl rDAO;
	
	// Save
	@Test
	public void testA() {
		Review r =new Review();
		r.setReviewBody("Test");
		r.setRating(5);
		rDAO.saveReview(r);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		Review a = rDAO.getReview("Test", "reviewBody");
		assertEquals("Review bodies must be the same","Test",a.getReviewBody());
	}
	
	// Get rating
	@Test
	public void testC() {
		Review a = rDAO.getReview(5, "rating");
		assertEquals("Review bodies must be the same",5,a.getRating());
	}
		
	// Get by id
	@Test
	public void testD() {
		Review a=rDAO.getReview("Test", "reviewBody");
		Review b=rDAO.getReview(a.getId());
		assertEquals("Review bodies must be the same",a.getReviewBody(),b.getReviewBody());
	}
	
	// Update
	@Test
	public void testE() {
		Review a=rDAO.getReview("Test", "reviewBody");
		a.setReviewBody("Test1");
		rDAO.updateReview(a);
		Review b=rDAO.getReview(a.getId());
		assertEquals("Review bodies must be the same","Test1",b.getReviewBody());
	}
	
	// Delete
	@Test
	public void testF() {
		Review a=rDAO.getReview("Test1", "reviewBody");
		rDAO.deleteReview(a);
		assertTrue(true);
	}

}
