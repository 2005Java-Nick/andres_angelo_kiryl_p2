package com.revature.readifined.dao;

import com.revature.readifined.domain.RegisteredAddress;

public interface RegisteredAddressDAO {

public RegisteredAddress getRegisteredAddress(int id);
	
	public RegisteredAddress getRegisteredAddress(String value, String column);
	
	public void saveRegisteredAddress(RegisteredAddress ra);
	
	public void updateRegisteredAddress(RegisteredAddress ra);
	
	public void deleteRegisteredAddress(RegisteredAddress ra);
}
