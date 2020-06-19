package com.revature.readifined.dao;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import com.revature.readifined.domain.Person;

@Repository
public class PersonDAOImpl implements PersonDAO{

	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}

	public Person getPerson(int id) {
		Session sess = sf.openSession();
		Person p = sess.get(Person.class, id);
		sess.close();
		return p;
	}

	public Person getPerson(String value,String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Person> cq = cb.createQuery(Person.class);
		Root<Person> rootEntry = cq.from(Person.class);
		CriteriaQuery<Person> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Person> allQuery = sess.createQuery(all);
		List<Person>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	public void savePerson(Person p) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(p);
		tx.commit();
		sess.close();	
	}

	public void updatePerson(Person p) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(p);
		tx.commit();
		sess.close();
		
	}

	public void deletePerson(Person p) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(p);
		tx.commit();
		sess.close();
		
	}
}
