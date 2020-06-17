package com.revature.readifined.services;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.revature.readifined.dao.PersonDAOImpl;
import com.revature.readifined.dao.RegisteredRoleDAOImpl;
import com.revature.readifined.dao.RoleDAOImpl;
import com.revature.readifined.domain.Person;
import com.revature.readifined.domain.RegisteredRole;
import com.revature.readifined.domain.Role;
import com.revature.readifined.domain.Session;
import com.revature.readifined.util.TokenGenerator;

@Service
public class RegisterUserServiceImpl implements RegisterUserService{

	PersonDAOImpl personDaoImpl;
	RoleDAOImpl roleDaoImpl;
	RegisteredRoleDAOImpl registeredRoleDaoIml;
	TokenGenerator tokenGenerator;
	
	@Autowired
	public void setPersonDaoImpl(PersonDAOImpl personDaoImpl)
	{
		this.personDaoImpl=personDaoImpl;
	}
	
	@Autowired
	public void setRoleDaoImpl(RoleDAOImpl roleDaoImpl)
	{
		this.roleDaoImpl=roleDaoImpl;
	}
	
	@Autowired
	public void setResgisteredRoleDaoImpl(RegisteredRoleDAOImpl registeredRoleDaoIml)
	{
		this.registeredRoleDaoIml=registeredRoleDaoIml;
	}
	
	@Autowired
	public void setTokenGenerator(TokenGenerator tokenGenerator)
	{
		this.tokenGenerator=tokenGenerator;
	}
	
	public Session createUser(String fn, String ln, String un, String pwd, String email, String dob, String phone,String role) {
		try {
			Person p=new Person();
			p.setFirstName(fn);
			p.setLastName(ln);
			p.setUserName(un);
			pwd= tokenGenerator.encryptPassword(pwd);
			p.setUserPassword(pwd);
			p.setEmail(email);
			System.out.println(dob);
			p.setDateOfBirth(LocalDate.parse(dob));
			p.setPhoneNumber(phone);
			personDaoImpl.savePerson(p);
			p=personDaoImpl.getPerson(un, "userName");
			Role r = roleDaoImpl.getRole(role);
			RegisteredRole rr=new RegisteredRole();
			rr.setPersonId(p.getId());
			rr.setUserRolesId(r.getId());
			registeredRoleDaoIml.saveRegisteredRole(rr);
			String token=tokenGenerator.generateToken();
			p.setToken(token);
			personDaoImpl.updatePerson(p);
			Session sess=new Session(p.getToken(), true);
			return sess;
		}catch(Exception e)
		{
			return new Session("",false);
		}
		
	} 
	

	
	
}
