package com.revature.readifined.dao;

import com.revature.readifined.domain.Permissions;

public interface PermissionsDAO {

    public Permissions getPermissions(int id);
	
	public Permissions getPermissions(String value,String column);
	
	public void savePermissions(Permissions pm);
	
	public void updatePermissions(Permissions pm);
	
	public void deletePermissions(Permissions pm);
	
}
