package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "readifined.permissions")
public class Permissions implements Serializable{

	private static final long serialVersionUID = -2229811290650587652L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	int id;
	@Column(name = "permission_type")
	String permissionType;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getPermissionType() {
		return permissionType;
	}
	public void setPermissionType(String permissionType) {
		this.permissionType = permissionType;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		result = prime * result + ((permissionType == null) ? 0 : permissionType.hashCode());
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
		Permissions other = (Permissions) obj;
		if (id != other.id)
			return false;
		if (permissionType == null) {
			if (other.permissionType != null)
				return false;
		} else if (!permissionType.equals(other.permissionType))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Permissions [id=" + id + ", permissionType=" + permissionType + "]";
	}
}
