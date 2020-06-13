package com.revature.readifined.util;

import java.util.HashMap;
import java.util.Map;

import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.model.naming.ImplicitNamingStrategyJpaCompliantImpl;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.springframework.stereotype.Component;
@Component
public class SessionFactoryUtil {
	
	private SessionFactory sf;

	private static String url;

	private static String username;

	private static String password;

	private static final String DB_NAME = System.getenv("DB_NAME");

	public SessionFactory getSessionFactory() {
		return this.sf;
	}

	public void setSessionFactory(SessionFactory sf) {
		this.sf = sf;
	}

	/*	Configured Environmental Variables
	 	DB_NAME
		PASSWORD
		URL
		USER_NAME
	 */
	
	public SessionFactoryUtil() {

		if (sf == null) {
			url = System.getenv("URL");
			url = "jdbc:postgresql://" + url + ":5432/" + "localhost" + "?";
			username = "postgres";
			password = "1992Andres_";
			Map<String, String> settings = new HashMap<String, String>();
			settings.put("hibernate.connection.driver_class", "org.postgresql.Driver");
			settings.put("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
			settings.put("hibernate.connection.url",
					"jdbc:postgresql://" + "localhost" + ":5432/" + "postgres" + "?");
			settings.put("hibernate.connection.username", username);
			settings.put("hibernate.connection.password", password);

			StandardServiceRegistry standardRegistry = new StandardServiceRegistryBuilder().applySettings(settings)
					.build();
			Metadata metadata = new MetadataSources(standardRegistry)
					.addAnnotatedClass(com.revature.readifined.domain.Person.class)
					.addAnnotatedClass(com.revature.readifined.domain.Role.class)
					.addAnnotatedClass(com.revature.readifined.domain.RegisteredRole.class)
					.addAnnotatedClass(com.revature.readifined.domain.Book.class)
					.getMetadataBuilder()
					.applyImplicitNamingStrategy(ImplicitNamingStrategyJpaCompliantImpl.INSTANCE).build();
			sf = metadata.getSessionFactoryBuilder().build();
		}

	}

}