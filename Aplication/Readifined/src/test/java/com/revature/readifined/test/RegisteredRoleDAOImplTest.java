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

import com.revature.readifined.config.AppConfig;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.domain.RegisteredRole;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class RegisteredRoleDAOImplTest {

	@Autowired
	RegisteredRoleDAOImpl rDao; 
	
	//Save
	@Test
	public void testA() {
		RegisteredRole r=new RegisteredRole();
		r.setPersonId(1);
		r.setUserRolesId(1);
		rDao.saveRegisteredRole(r);
		assertTrue(true);
	}
	
	//Get
	@Test
	public void testB() {                        
		RegisteredRole r1=rDao.getRegisteredRole(1, "personId");
		assertEquals("Object are the same", 1,r1.getPersonId());
	}
	
	//Get Person Id
	@Test
	public void testC() {                        
		RegisteredRole r1=rDao.getRegisteredRole(1, "personId");
		RegisteredRole r2=rDao.getRegisteredRole(r1.getId());
		assertEquals("Object are the same", r1.getId(),r2.getId());
	}
	
	
	//Update
	@Test
	public void testD() {                        
		RegisteredRole r1=rDao.getRegisteredRole(1, "personId");
		r1.setPersonId(1);
		r1.setUserRolesId(2);
		rDao.updateRegisteredRole(r1);
		RegisteredRole r2=rDao.getRegisteredRole(r1.getId());
		assertEquals("Object are the same", 2,r2.getUserRolesId());
	}	
	
	//Delete
	@Test
	public void testE() {
		RegisteredRole r1=rDao.getRegisteredRole(1, "personId");
		rDao.deleteRegisteredRole(r1);
		assertTrue(true);
	}
	
}
