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
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.Role;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class RoleDAOImplTest {

	@Autowired
	RoleDAOImpl rDao;
	
	//Save
	@Test
	public void testA() {
		Role r=new Role();
		r.setRoleType("TestRole");
		rDao.saveRole(r);
		assertTrue(true);
	}
	
	//Get
	@Test
	public void testB() {                        
		Role r1=rDao.getRole("TestRole");
		assertEquals("Object are the same", "TestRole",r1.getRoleType());
	}
	
	//Get Person Id
	@Test
	public void testC() {                        
		Role r1=rDao.getRole("TestRole");
		Role r2=rDao.getRole(r1.getId());
		assertEquals("Object are the same", r1.getRoleType(),r2.getRoleType());
	}
	
	
	//Update
	@Test
	public void testD() {                        
		Role r1=rDao.getRole("TestRole");
		r1.setRoleType("TestRole1");
		rDao.updateRole(r1);
		Role r2=rDao.getRole("TestRole1");
		assertEquals("Object are the same", "TestRole1",r2.getRoleType());
	}	
	
	//Delete
	@Test
	public void testE() {
		
		Role r=rDao.getRole("TestRole1");
		rDao.deleteRole(r);
		assertTrue(true);
	}

}
