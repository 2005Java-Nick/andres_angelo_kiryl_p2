package com.revature.readifined.services;

import com.revature.readifined.domain.Session;

public interface LoginService {
	public Session login(String username,String password);
}
