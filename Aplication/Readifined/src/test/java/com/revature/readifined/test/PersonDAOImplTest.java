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
import com.revature.readifined.config.AppConfig;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.domain.Person;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class PersonDAOImplTest {

	@Autowired
	PersonDAOImpl pDao;
	
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
		pDao.savePerson(p);
		assertTrue(true);
	}
	
	//Get
	@Test
	public void testB() {                        
		Person p1=pDao.getPerson("DoomSlayer","userName");
		assertEquals("Object are the same", "DoomSlayer",p1.getUserName());
	}
	
	//Get Person Id
	@Test
	public void testC() {                        
		Person p1=pDao.getPerson("DoomSlayer","userName");
		Person p2=pDao.getPerson(p1.getId());
		assertEquals("Object are the same", p1.getUserName(),p2.getUserName());
	}
	
	
	//Update
	@Test
	public void testD() {                        
		Person p1=pDao.getPerson("DoomSlayer","userName");
		p1.setUserName("DoomSlayer1");
		pDao.updatePerson(p1);
		Person p2=pDao.getPerson("DoomSlayer1","userName");
		assertEquals("Object are the same", "DoomSlayer1",p2.getUserName());
	}	
	
	//Delete
	@Test
	public void testE() {
		
		Person p=pDao.getPerson("DoomSlayer1", "userName");
		pDao.deletePerson(p);
		assertTrue(true);
	}

}
