package com.revature.readifined.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.time.LocalDate;

import org.junit.Before;
import org.junit.BeforeClass;
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
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredAddressDAOImpl;
import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.AddressType;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.RegisteredAddress;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class RegisteredAddressDAOImplTest {

	@Autowired
	RegisteredAddressDAOImpl rDao; 
	@Autowired
	PersonDAOImpl pDAO;
	@Autowired
	AddressDAOImpl aDAO;
	@Autowired
	AddressTypeDAOImpl atDAO;
	
	Person p1;
	Person p2;
	Address a1;
	AddressType at1;
	
	@Test
	public void setup()
	{
		//Test person
		Person p=new Person();
		p.setDateOfBirth(LocalDate.now());                 
		p.setFirstName("Andres");
		p.setLastName("Toledo");
		p.setUserName("DoomSlayer");
		p.setUserPassword("1992Andres_");
		p.setEmail("amtamusic@hotmail.com");
		p.setPhoneNumber("7186199163");
		pDAO.savePerson(p);
		p1=pDAO.getPerson(p.getUserName(), "userName");
		p=new Person();		
		p.setDateOfBirth(LocalDate.now());                 
		p.setFirstName("Andres1");
		p.setLastName("Toledo1");
		p.setUserName("DoomSlayer1");
		p.setUserPassword("1992Andres_1");
		p.setEmail("amtamusic@hotmail.com1");
		p.setPhoneNumber("7186199163");
		pDAO.savePerson(p);
		p2=pDAO.getPerson(p.getUserName(), "userName");
		//Test Address
		Address aTest=new Address();
		aTest.setCity("Test1");
		aTest.setState("Test2");
		aTest.setStreetName("Test3");
		aTest.setStreetNumber(21);
		aTest.setZipCode(10314);
		aDAO.saveAddress(aTest);
		//Test Address Type
		AddressType aType=new AddressType();
		aType.setDescription("Home");
		atDAO.saveAddress(aType);
		//Retrieve id's
		a1=aDAO.getAddress("Test1", "city");
		at1=atDAO.getAddressType("Home", "description");
		assertTrue(true);
	}
	
	
	//Save
	@Test
	public void testA() {
		//Test Registered Address
		System.out.println("Person id:"+p1.getId());
		RegisteredAddress ra =new RegisteredAddress();
		ra.setPersonId(p1.getId());
		ra.setAddressTypeId(at1.getId());
		ra.setAddressId(a1.getId());
		rDao.saveRegisteredAddress(ra);
		assertTrue(true);
	}
	
	//Get
	@Test
	public void testB() {          
		System.out.println("Person id:"+p1.getId());
		RegisteredAddress ra = rDao.getRegisteredAddress(p1.getId(), "personId");
		assertEquals("Object are the same", p1.getId(),ra.getPersonId());
	}
	
	//Get Person Id
	@Test
	public void testC() {                        
		RegisteredAddress r1=rDao.getRegisteredAddress(p1.getId(), "personId");
		RegisteredAddress r2=rDao.getRegisteredAddress(r1.getId());
		assertEquals("Object are the same", r1.getId(),r2.getId());
	}
	
	
	//Update
	@Test
	public void testD() {       
		RegisteredAddress r1=rDao.getRegisteredAddress(p1.getId(), "personId");
		r1.setPersonId(p2.getId());
		rDao.updateRegisteredAddress(r1);
		RegisteredAddress r2=rDao.getRegisteredAddress(r1.getId());
		assertEquals("Object are the same", p2.getId(),r2.getPersonId());
	}	
	
	//Delete
	@Test
	public void testE() {
		RegisteredAddress r1=rDao.getRegisteredAddress(p1.getId(), "personId");
		rDao.deleteRegisteredAddress(r1);
		pDAO.deletePerson(p1);
		pDAO.deletePerson(p2);
		atDAO.deleteAddress(at1);
		aDAO.deleteAddress(a1);
		assertTrue(true);
	}
	
}
