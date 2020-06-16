package com.revature.readifined.services;

import com.revature.readifined.domain.Session;

public interface AuthorizationService {
	public Session authorize(String username, String token);
}
