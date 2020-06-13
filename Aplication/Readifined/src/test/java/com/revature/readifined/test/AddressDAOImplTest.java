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
import com.revature.readifined.domain.Address;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class AddressDAOImplTest {

	@Autowired
	AddressDAOImpl aDAO;
	
	// Save
	@Test
	public void testA() {
		Address a =new Address();
		a.setCity("City Test");
		a.setState("NY");
		a.setStreetName("Washington Ave");
		a.setStreetNumber(12);
		a.setZipCode(10314);
		aDAO.saveAddress(a);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		Address a=aDAO.getAddress("NY", "state");
		assertEquals("Cities should be the same","NY",a.getState());
	}
	// Get by id
	@Test
	public void testC() {
		Address a=aDAO.getAddress("NY", "state");
		Address b=aDAO.getAddress(a.getId());
		assertEquals("Cities should be the same",a.getState(),b.getState());
	}
	
	// Update
	@Test
	public void testD() {
		Address a=aDAO.getAddress("NY", "state");
		a.setCity("NJ");
		aDAO.updateAddress(a);
		assertEquals("Cities should be the same","NJ",a.getCity());
	}
	
	// Delete
	@Test
	public void testE() {
		Address a=aDAO.getAddress("NY", "state");
		aDAO.deleteAddress(a);
		assertTrue(true);
	}

}
