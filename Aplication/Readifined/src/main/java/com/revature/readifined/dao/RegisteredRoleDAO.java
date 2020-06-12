package com.revature.readifined.dao;

import com.revature.readifined.domain.RegisteredRole;

public interface RegisteredRoleDAO {

	public RegisteredRole getRegisteredRole(int id);
	
	public RegisteredRole getRegisteredRole(int value, String column);
	
	public void updateRegisteredRole(RegisteredRole rr);
	
	public void deleteRegisteredRole(RegisteredRole rr);

	
}
