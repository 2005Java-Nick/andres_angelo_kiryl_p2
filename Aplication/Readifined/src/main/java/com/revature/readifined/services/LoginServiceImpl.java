package com.revature.readifined.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.RegisteredRole;
import com.revature.readifined.domain.Role;

@Service
public class LoginServiceImpl implements LoginService{

	PersonDAOImpl personDAOImpl;
	
	RegisteredRoleDAOImpl registeredRoleDAOImpl;
	
	RoleDAOImpl roleDAOImpl;
	
	@Autowired
	public void setPersonDAO(PersonDAOImpl personDaoImpl)
	{
		this.personDAOImpl=personDaoImpl;
	}
	
	@Autowired
	public void setRegisteredRoleDAO(RegisteredRoleDAOImpl registeredRoleDAOImpl)
	{
		this.registeredRoleDAOImpl=registeredRoleDAOImpl;
	}
	
	@Autowired
	public void setRegisteredRoleDAO(RoleDAOImpl roleDAOImpl)
	{
		this.roleDAOImpl=roleDAOImpl;
	}
	
	public Role login(String username, String password) {
		Role role =null;
		try {
			Person user=personDAOImpl.getPerson(username, "userName");
			RegisteredRole rRole=null;
			if(user!=null)
			{
				if(user.getUserPassword().equals(password))
				{
					rRole= registeredRoleDAOImpl.getRegisteredRole(user.getId(), "personId");
					role= roleDAOImpl.getRole(rRole.getUserRolesId());
					return role;
				}
			}
		}catch (Exception e) {
			return role;
		}
		return role;
	}

}
