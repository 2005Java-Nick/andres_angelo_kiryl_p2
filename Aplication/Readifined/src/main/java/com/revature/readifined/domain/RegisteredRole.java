package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "readifined.registered_role")
public class RegisteredRole implements Serializable {

	private static final long serialVersionUID = 4680506217042651481L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	@Column(name = "person_id")
	private int personId;
	@Column(name = "user_roles_id")
	private int userRolesId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPersonId() {
		return personId;
	}
	public void setPersonId(int personId) {
		this.personId = personId;
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
		result = prime * result + personId;
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
		RegisteredRole other = (RegisteredRole) obj;
		if (id != other.id)
			return false;
		if (personId != other.personId)
			return false;
		if (userRolesId != other.userRolesId)
			return false;
		return true;
	}
	
}
