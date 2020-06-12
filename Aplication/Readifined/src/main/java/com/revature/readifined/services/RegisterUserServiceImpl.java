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

@Service
public class RegisterUserServiceImpl implements RegisterUserService{

	PersonDAOImpl personDaoImpl;
	RoleDAOImpl roleDaoImpl;
	RegisteredRoleDAOImpl registeredRoleDaoIml;
	
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
	
	public boolean createUser(String fn, String ln, String un, String pwd, String email, String dob, String phone,String role) {
		Person p=new Person();
		p.setFirstName(fn);
		p.setLastName(ln);
		p.setUserName(un);
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
		return true;
	}
	

	
	
}
