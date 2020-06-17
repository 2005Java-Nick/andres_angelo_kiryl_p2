package com.revature.readifined.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.PropertyNamingStrategy.PascalCaseStrategy;
import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.Session;
@Service
public class AuthorizationServiceImpl implements AuthorizationService{

	PersonDAOImpl personDAOImpl;
	
	@Autowired
	public void setPersonDAOImpl(PersonDAOImpl personDAOImpl)
	{
		this.personDAOImpl = personDAOImpl;
	}
	
	@Override
	public Session authorize(String username, String token) {
		token=token.replace(" ", "+");
		System.out.println(username+":"+token);
		Session sess=new Session(token, false);
		try
		{
			Person user =personDAOImpl.getPerson(username, "userName");
			if(user.getToken().equals(token))
			{
				sess.setVerified(true);
				return sess;
			}
			else 
			{
				return sess;
			}
		}catch(Exception e)
		{
			
		}
		return sess;
	}

}
