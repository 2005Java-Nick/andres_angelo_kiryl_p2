package com.revature.readifined.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

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
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.RegisteredRole;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class RegisteredRoleDAOImplTest {

	@Autowired
	RegisteredRoleDAOImpl rDao; 
	@Autowired
	PersonDAOImpl pDAO;
	
	//Save
	@Test
	public void testA() {
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
		RegisteredRole r=new RegisteredRole();
		r.setPersonId(p.getId());
		r.setUserRolesId(1);
		rDao.saveRegisteredRole(r);
		assertTrue(true);
	}
	
	//Get
	@Test
	public void testB() {               
		Person p=pDAO.getPerson("DoomSlayer","userName");
		RegisteredRole r1=rDao.getRegisteredRole(p.getId(), "personId");
		assertEquals("Object are the same", p.getId(),r1.getPersonId());
	}
	
	//Get Person Id
	@Test
	public void testC() {                        
		Person p=pDAO.getPerson("DoomSlayer","userName");
		RegisteredRole r1=rDao.getRegisteredRole(p.getId(), "personId");
		RegisteredRole r2=rDao.getRegisteredRole(r1.getId());
		assertEquals("Object are the same", r1.getId(),r2.getId());
	}
	
	
	//Update
	@Test
	public void testD() {       
		Person p=pDAO.getPerson("DoomSlayer","userName");
		RegisteredRole r1=rDao.getRegisteredRole(p.getId(), "personId");
		r1.setPersonId(p.getId());
		r1.setUserRolesId(2);
		rDao.updateRegisteredRole(r1);
		RegisteredRole r2=rDao.getRegisteredRole(r1.getId());
		assertEquals("Object are the same", 2,r2.getUserRolesId());
	}	
	
	//Delete
	@Test
	public void testE() {
		Person p=pDAO.getPerson("DoomSlayer","userName");
		RegisteredRole r1=rDao.getRegisteredRole(p.getId(), "personId");
		rDao.deleteRegisteredRole(r1);
		pDAO.deletePerson(p);
		assertTrue(true);
	}
	
}
