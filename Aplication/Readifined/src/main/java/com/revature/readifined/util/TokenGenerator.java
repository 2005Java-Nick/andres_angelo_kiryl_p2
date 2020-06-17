package com.revature.readifined.util;

import java.util.Random;

import org.jasypt.util.password.StrongPasswordEncryptor;
import org.springframework.stereotype.Component;
@Component
public class TokenGenerator {
	
	public String generateToken()
	{
		int seed = new Random().nextInt(999999999);
		StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
		String token = passwordEncryptor.encryptPassword(seed+"");
		return token;
	}
	
	public String encryptPassword(String password)
	{
		StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
		String encryptedPassword = passwordEncryptor.encryptPassword(password);
		return encryptedPassword;
	}
	
	public boolean validatePassword(String password,String encryptedPassword)
	{
		StrongPasswordEncryptor passwordEncryptor = new StrongPasswordEncryptor();
		if (passwordEncryptor.checkPassword(password, encryptedPassword)) {
			return true;
		} else {
			return false;
		}
	}
	
	
}
