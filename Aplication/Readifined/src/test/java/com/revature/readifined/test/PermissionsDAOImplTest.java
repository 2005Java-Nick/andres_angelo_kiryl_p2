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
import com.revature.readifined.dao.PermissionsDAOImpl;
import com.revature.readifined.domain.Permissions;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class PermissionsDAOImplTest {

	@Autowired
	PermissionsDAOImpl pDAO;
	
	// Save
		@Test
		public void testA() {
			Permissions p =new Permissions();
			p.setPermissionType("Test");
			pDAO.savePermissions(p);
			assertTrue(true);
		}
		
		// Get
		@Test
		public void testB() {
			Permissions a=pDAO.getPermissions("Test", "permissionType");
			assertEquals("Persmission should have name Test","Test",a.getPermissionType());
		}
		// Get by id
		@Test
		public void testC() {
			Permissions a=pDAO.getPermissions("Test", "permissionType");
			Permissions b=pDAO.getPermissions(a.getId());
			assertEquals("Persmission should have name Test",a.getPermissionType(),b.getPermissionType());
		}
		
		// Update
		@Test
		public void testD() {
			Permissions a=pDAO.getPermissions("Test", "permissionType");
			a.setPermissionType("Test1");
			pDAO.updatePermissions(a);
			assertEquals("Persmission should have name Test1","Test1",a.getPermissionType());
		}
		
		// Delete
		@Test
		public void testE() {
			Permissions a=pDAO.getPermissions("Test1", "permissionType");
			pDAO.deletePermissions(a);
			assertTrue(true);
		}

}
