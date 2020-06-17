package com.revature.readifined.services;

import com.revature.readifined.domain.Session;

public interface RegisterUserService {
	public Session createUser(String fn, String ln, String un,String pwd,String email,String dob, String phone,String role);
}
 