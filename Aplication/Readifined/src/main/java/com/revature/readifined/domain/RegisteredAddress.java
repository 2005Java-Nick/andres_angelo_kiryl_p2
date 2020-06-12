package com.revature.readifined.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

public class RegisteredAddress implements Serializable {

	private static final long serialVersionUID = 5603528551790292602L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	@Column(name = "person_id")
	private int personId;
	@Column(name = "address_id")
	private int addressId;
	@Column(name = "address_type_id")
	private int addressTypeId;
	
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
	public int getAddressId() {
		return addressId;
	}
	public void setAddressId(int addressId) {
		this.addressId = addressId;
	}
	public int getAddressTypeId() {
		return addressTypeId;
	}
	public void setAddressTypeId(int addressTypeId) {
		this.addressTypeId = addressTypeId;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + addressId;
		result = prime * result + addressTypeId;
		result = prime * result + id;
		result = prime * result + personId;
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
		RegisteredAddress other = (RegisteredAddress) obj;
		if (addressId != other.addressId)
			return false;
		if (addressTypeId != other.addressTypeId)
			return false;
		if (id != other.id)
			return false;
		if (personId != other.personId)
			return false;
		return true;
	}
	
	
}
