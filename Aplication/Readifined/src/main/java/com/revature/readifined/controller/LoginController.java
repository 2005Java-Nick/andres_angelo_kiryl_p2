package com.revature.readifined.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.revature.readifined.domain.Role;
import com.revature.readifined.domain.Session;
import com.revature.readifined.services.LoginService;

@Controller
public class LoginController {

	private LoginService loginService;
	
	@Autowired
	public void setLoginService (LoginService loginService)
	{
		this.loginService=loginService;
	}
	
	@RequestMapping(path = "/login", method = RequestMethod.POST)
	@ResponseBody
	public Session getlogin(@RequestParam(name = "session", required = false) String sess,@RequestParam(name = "username", required = true) String username,@RequestParam(name = "password", required = true) String password) {
		if (sess==null)
		{
			System.out.println("Does not have session");
			return loginService.login(username, password);
		}
		else
		{
			System.out.println("Has session");
			
			return new Session(sess,true);
		}
	}

}
