package com.revature.readifined.dao;


import com.revature.readifined.domain.AssignedPermissions;

public interface AssignedPermissionsDAO{

	public AssignedPermissions  getAssignedPermissions(int id);
	
    public AssignedPermissions getAssignedPermissions(int value, String column);
	
	public void saveAssignedPermissions(AssignedPermissions ap);
	
	public void updateAssignedPermissions(AssignedPermissions ap);
	
	public void deleteAssignedPermissions(AssignedPermissions ap);
}
