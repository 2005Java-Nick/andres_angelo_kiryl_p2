package com.revature.readifined.dao;

import com.revature.readifined.domain.Tag;

public interface TagDAO {

    public Tag getTag(int id);
	
	public Tag getTag(String value, String column);
	
	public void saveTag(Tag t);
	
	public void updateTag(Tag t);
	
	public void deleteTag(Tag t);
}
