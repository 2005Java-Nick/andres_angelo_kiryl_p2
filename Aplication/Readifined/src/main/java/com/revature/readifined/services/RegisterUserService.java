package com.revature.readifined.services;

public interface RegisterUserService {
	public boolean createUser(String fn, String ln, String un,String pwd,String email,String dob, String phone,String role);
}
 