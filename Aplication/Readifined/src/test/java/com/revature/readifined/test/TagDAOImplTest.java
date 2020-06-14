package com.revature.readifined.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.revature.readifined.config.AppConfig;
import com.revature.readifined.dao.ReviewDAOImpl;
import com.revature.readifined.dao.TagDAOImpl;
import com.revature.readifined.domain.Review;
import com.revature.readifined.domain.Tag;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class TagDAOImplTest {

	@Autowired
	TagDAOImpl tDAO;
	
	// Save
	@Test
	public void testA() {
		Tag a =new Tag();
		a.setTagName("Test");
		tDAO.saveTag(a);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		Tag a=tDAO.getTag("Test", "tagName");
		assertEquals("Tag name should be the same", "Test", a.getTagName());
	}
	
	// Get rating
	@Test
	public void testC() {
		Tag a=tDAO.getTag("Test", "tagName");
		Tag b=tDAO.getTag(a.getId());
		assertEquals("Tag name should be the same", a.getTagName(), b.getTagName());
	}
		
	// Update
	@Test
	public void testD() {
		Tag a=tDAO.getTag("Test", "tagName");
		a.setTagName("Test1");
		tDAO.updateTag(a);
		assertEquals("Tag name should be the same", "Test1", a.getTagName());
	}
	
	// Delete
	@Test
	public void testF() {
		Tag a=tDAO.getTag("Test1", "tagName");
		tDAO.deleteTag(a);
		assertTrue(true);
	}


}
