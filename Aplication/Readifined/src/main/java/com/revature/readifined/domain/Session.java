package com.revature.readifined.domain;

public class Session {
	String token;
	boolean verified;

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}
	
	public Session(String token,boolean verified)
	{
		this.token=token;
		this.verified=verified;
	}

	public boolean isVerified() {
		return verified;
	}

	public void setVerified(boolean verified) {
		this.verified = verified;
	}


	
}
