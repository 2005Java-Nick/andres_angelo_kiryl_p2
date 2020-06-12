package com.revature.readifined.dao;

import com.revature.readifined.domain.Address;

public interface AddressDAO {

	public Address getAddress(int id);
	
	public Address getAddress(String value, String column);
	
	public void saveAddress(Address a);
	
	public void updateAddress(Address a);
	
	public void deleteAddress(Address a);
	
}