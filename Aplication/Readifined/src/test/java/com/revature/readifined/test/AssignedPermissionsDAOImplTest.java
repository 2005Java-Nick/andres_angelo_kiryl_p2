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
import com.revature.readifined.dao.AssignedPermissionsDAOImpl;
import com.revature.readifined.dao.PermissionsDAOImpl;
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.AssignedPermissions;
import com.revature.readifined.domain.Permissions;
import com.revature.readifined.domain.Role;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@WebAppConfiguration
public class AssignedPermissionsDAOImplTest {

		@Autowired
		AssignedPermissionsDAOImpl apDAO;
		@Autowired
		RoleDAOImpl rDAO;
		@Autowired
		PermissionsDAOImpl pDAO;
		
		Permissions p;
		Role r;
		Role r1;
	
		public void setup()
		{
			p=new Permissions();
			p.setPermissionType("Test");
			pDAO.savePermissions(p);
			r=new Role();
			r.setRoleType("Test");
			r1=new Role();
			r1.setRoleType("Test1");
			rDAO.saveRole(r);
			rDAO.saveRole(r1);
			p=pDAO.getPermissions("Test", "permissionType");
			r=rDAO.getRole("Test");
			r1=rDAO.getRole("Test1");
		}
		
		public void setupNoSave()
		{
			p=pDAO.getPermissions("Test", "permissionType");
			r=rDAO.getRole("Test");
			r1=rDAO.getRole("Test1");
		}
	
		// Save
		@Test
		public void testA() {
			setup();
			AssignedPermissions ap =new AssignedPermissions();
			ap.setPermissionsId(p.getId());
			ap.setUserRolesId(r.getId());
			apDAO.saveAssignedPermissions(ap);
			assertTrue(true);
		}
		
		// Get
		@Test
		public void testB() {
			setupNoSave();
			AssignedPermissions ap=apDAO.getAssignedPermissions(p.getId(), "permissionsId");
			assertEquals("Assigned permission should have the same id as permission",p.getId(),ap.getPermissionsId());
		}
		// Get by id
		@Test
		public void testC() {
			setupNoSave();
			AssignedPermissions ap=apDAO.getAssignedPermissions(p.getId(), "permissionsId");
			AssignedPermissions ap1=apDAO.getAssignedPermissions(ap.getId());
			assertEquals("Permission should have name Test",ap.getPermissionsId(),ap1.getPermissionsId());
		}
		
		// Update
		@Test
		public void testD() {
			setupNoSave();
			AssignedPermissions ap=apDAO.getAssignedPermissions(p.getId(), "permissionsId");
			ap.setUserRolesId(r1.getId());
			apDAO.updateAssignedPermissions(ap);
			AssignedPermissions ap1=apDAO.getAssignedPermissions(r1.getId(), "userRolesId");
			assertEquals("Persmission should have name Test1",r1.getId(),ap1.getUserRolesId());
		}
		
		// Delete
		@Test
		public void testE() {
			setupNoSave();
			AssignedPermissions ap=apDAO.getAssignedPermissions(r1.getId(), "userRolesId");
			apDAO.deleteAssignedPermissions(ap);
			pDAO.deletePermissions(p);
			rDAO.deleteRole(r);
			rDAO.deleteRole(r1);
			assertTrue(true);
		}

}
