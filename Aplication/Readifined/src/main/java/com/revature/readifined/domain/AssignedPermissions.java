package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "readifined.assigned_permissions")
public class AssignedPermissions implements Serializable{

	private static final long serialVersionUID = 1949586839345771850L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	int id;
	@Column(name = "permissions_id")
	int permissionsId;
	@Column(name = "user_roles_id")
	int userRolesId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPermissionsId() {
		return permissionsId;
	}
	public void setPermissionsId(int permissionsId) {
		this.permissionsId = permissionsId;
	}
	public int getUserRolesId() {
		return userRolesId;
	}
	public void setUserRolesId(int userRolesId) {
		this.userRolesId = userRolesId;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		result = prime * result + permissionsId;
		result = prime * result + userRolesId;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AssignedPermissions other = (AssignedPermissions) obj;
		if (id != other.id)
			return false;
		if (permissionsId != other.permissionsId)
			return false;
		if (userRolesId != other.userRolesId)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "AssignedPermissions [id=" + id + ", permissionsId=" + permissionsId + ", user_roles_id=" + userRolesId
				+ "]";
	}
	
	
}
