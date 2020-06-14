package com.revature.readifined.services;

import com.revature.readifined.domain.Role;

public interface LoginService {
	public Role login(String username,String password);
}
