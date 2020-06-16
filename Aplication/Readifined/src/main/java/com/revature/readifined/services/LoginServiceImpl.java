package com.revature.readifined.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.RegisteredRole;
import com.revature.readifined.domain.Role;
import com.revature.readifined.domain.Session;

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
	
	public Session login(String username, String password) {
		Session ses =null;
		try {
			Person user=personDAOImpl.getPerson(username, "userName");
			if(user!=null)
			{
				if(user.getUserPassword().equals(password))
				{
					ses=new Session("session goes here",true);
					user.setToken(ses.getToken());
					personDAOImpl.updatePerson(user);
					return ses;
				}
			}
		}catch (Exception e) {
			return new Session("", false);
		}
		return new Session("", false);
	}

}
