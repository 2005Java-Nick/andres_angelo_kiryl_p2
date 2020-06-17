package com.revature.readifined.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.revature.readifined.domain.Session;
import com.revature.readifined.services.RegisterUserServiceImpl;
@Controller
public class RegistrationController {

	private RegisterUserServiceImpl registeredUserServiceImpl;
	
	@Autowired
	public void setRegisteredUserService(RegisterUserServiceImpl registeredUserServiceImpl)
	{
		this.registeredUserServiceImpl=registeredUserServiceImpl;
	}
	
	@RequestMapping(path = "/register", method = RequestMethod.POST)
	@ResponseBody
	public Session createUserCustomer(@RequestParam(name = "firstname",required = true)String fn,
			@RequestParam(name = "lastname",required = true)String ln,
			@RequestParam(name = "username",required = true)String un,
			@RequestParam(name = "password",required = true)String pwd,
			@RequestParam(name = "email",required = true)String email,
			@RequestParam(name = "dob",required = true)String dob,
			@RequestParam(name = "phone",required = true)String phone,
			@RequestParam(name = "role",required = true)String roleS)
	{
		boolean role=Boolean.parseBoolean(roleS);
		if(role) {
			return registeredUserServiceImpl.createUser(fn, ln, un, pwd, email, dob, phone, "Author");
		}
		return registeredUserServiceImpl.createUser(fn, ln, un, pwd, email, dob, phone, "Customer");
	}
	
	
	
}
