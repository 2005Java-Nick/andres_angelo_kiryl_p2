package com.revature.readifined.dao;

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

import com.revature.readifined.domain.Address;
@Repository
public class AddressDAOImpl implements AddressDAO {

	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory; 
	}	
	
	
	@Override
	public Address getAddress(int id) {
		Session sess = sf.openSession();
		Address a = sess.get(Address.class, id);
		sess.close();
		return a;
	}

	@Override
	public Address getAddress(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Address> cq = cb.createQuery(Address.class);
		Root<Address> rootEntry = cq.from(Address.class);
		CriteriaQuery<Address> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Address> allQuery = sess.createQuery(all);
		List<Address> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);	
	}

	@Override
	public void saveAddress(Address a) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(a);
		tx.commit();
		sess.close();		
	}

	@Override
	public void updateAddress(Address a) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(a);
		tx.commit();
		sess.close();	
		
	}

	@Override
	public void deleteAddress(Address a) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(a);
		tx.commit();
		sess.close();	
		
	}

}
