package com.revature.readifined.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.domain.Person;

@Service
public class LoginServiceImpl implements LoginService{

	PersonDAOImpl personDAOImpl;
	
	@Autowired
	public void setPersonDAO(PersonDAOImpl personDaoImpl)
	{
		this.personDAOImpl=personDaoImpl;
	}
	
	public boolean login(String username, String password) {
		Person user=personDAOImpl.getPerson(username, "userName");
		if(user!=null)
		{
			if(user.getUserPassword().equals(password))
			{
				return true;
			}
		}
		return false;
	}

}
