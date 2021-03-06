package com.revature.readifined.config;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.annotation.Scope;

import com.revature.readifined.util.SessionFactoryUtil;

@Configuration
@ComponentScan(value = "com.revature")
//@ComponentScan(value = "com.revature",excludeFilters = { @Filter(type = FilterType.ANNOTATION, value = Configuration.class) })
public class AppConfig {
	
	private SessionFactoryUtil sessionFactoryUtil;
	
	@Autowired
	public void setSessionFactoryUtil(SessionFactoryUtil sessionFactoryUtil) {
		this.sessionFactoryUtil = sessionFactoryUtil;
	}
	
	@Bean
	@Scope("singleton")
	public SessionFactory sessionFactory() {
		return sessionFactoryUtil.getSessionFactory();
	}
}
