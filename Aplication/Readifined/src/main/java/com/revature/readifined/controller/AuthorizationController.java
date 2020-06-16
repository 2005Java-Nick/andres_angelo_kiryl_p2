package com.revature.readifined.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.revature.readifined.domain.Session;
import com.revature.readifined.services.AuthorizationService;

@Controller
public class AuthorizationController {

private AuthorizationService authorizationService;
	
	@Autowired
	public void setLoginService (AuthorizationService authorizationService)
	{
		this.authorizationService=authorizationService;
	}
	
	@RequestMapping(path = "/authorize", method = RequestMethod.POST)
	@ResponseBody
	public Session getlogin(@RequestParam(name = "session", required = false) String sess,@RequestParam(name = "username", required = true) String username) {
		if (sess==null)
		{
			return new Session("", false);
		}
		else
		{	
			return authorizationService.authorize(username, sess);
		}
	}
	
}
