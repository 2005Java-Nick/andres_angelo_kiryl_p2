package com.revature.readifined.dao;

import com.revature.readifined.domain.Person;

public interface PersonDAO {
	
	public Person getPerson(int id);
	
	public Person getPerson(String value,String column);
	
	public void savePerson(Person p);
	
	public void updatePerson(Person p);
	
	public void deletePerson(Person p);

}
