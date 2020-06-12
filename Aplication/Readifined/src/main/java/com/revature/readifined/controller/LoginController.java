package com.revature.readifined.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.revature.readifined.services.LoginService;

@Controller
public class LoginController {

	private LoginService loginService;
	
	@Autowired
	public void setLoginService (LoginService loginService)
	{
		this.loginService=loginService;
	}
	
	@RequestMapping(path = "/login", method = RequestMethod.GET)
	@ResponseBody
	public boolean getRandomCards(@RequestParam(name = "username", required = true) String username,@RequestParam(name = "password", required = true) String password) {
		return loginService.login(username, password);
	}
	
	
}
