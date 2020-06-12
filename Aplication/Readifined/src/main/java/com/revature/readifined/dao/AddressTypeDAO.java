package com.revature.readifined.dao;

import com.revature.readifined.domain.AddressType;

public interface AddressTypeDAO {

public AddressType getAddressType(int id);
	
	public AddressType getAddressType(String value, String column);
	
	public void saveAddress(AddressType at);
	
	public void updateAddress(AddressType at);
	
	public void deleteAddress(AddressType at);
}
