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
import com.revature.readifined.dao.AddressTypeDAOImpl;
import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.AddressType;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class AddressTypeDAOImplTest {

	@Autowired
	AddressTypeDAOImpl aDAO;
	
	// Save
	@Test
	public void testA() {
		AddressType a =new AddressType();
		a.setDescription("Home");
		aDAO.saveAddress(a);
		assertTrue(true);
	}
	
	// Get
	@Test
	public void testB() {
		AddressType a=aDAO.getAddressType("Home", "description");
		assertEquals("Address description should be the same","Home",a.getDescription());
	}
	// Get by id
	@Test
	public void testC() {
		AddressType a=aDAO.getAddressType("Home", "description");
		AddressType b=aDAO.getAddressType(a.getId());
		assertEquals("Address id should be the same",a.getId(),b.getId());
	}
	
	// Update
	@Test
	public void testD() {
		AddressType a=aDAO.getAddressType("Home", "description");
		a.setDescription("Shipping");
		aDAO.updateAddress(a);
		AddressType b=aDAO.getAddressType("Shipping", "description");
		assertEquals("Address description should be the same","Shipping",b.getDescription());
	}
	
	// Delete
	@Test
	public void testE() {
		AddressType a=aDAO.getAddressType("Shipping", "description");
		aDAO.deleteAddress(a);
		assertTrue(true);
	}

}
