package com.revature.readifined.dao;

import com.revature.readifined.domain.Role;

public interface RoleDAO {
		
	public Role getRole(int id);
	
	public Role getRole(String roleName);
	
	public void saveRole(Role r);
	
	public void updateRole(Role r);
	
	public void deleteRole(Role r);
	
	
}
