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

import com.revature.readifined.domain.Address;
import com.revature.readifined.domain.AddressType;

public class AddressTypeDAOImpl implements AddressTypeDAO {

	public SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory; 
	}	
	
	@Override
	public AddressType getAddressType(int id) {
		Session sess = sf.openSession();
		AddressType at = sess.get(AddressType.class, id);
		sess.close();
		return at;
	}

	@Override
	public AddressType getAddressType(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<AddressType> cq = cb.createQuery(AddressType.class);
		Root<AddressType> rootEntry = cq.from(AddressType.class);
		CriteriaQuery<AddressType> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<AddressType> allQuery = sess.createQuery(all);
		List<AddressType> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);	
	}

	@Override
	public void saveAddress(AddressType at) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(at);
		tx.commit();
		sess.close();	
	}

	@Override
	public void updateAddress(AddressType at) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(at);
		tx.commit();
		sess.close();	
		
	}

	@Override
	public void deleteAddress(AddressType at) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(at);
		tx.commit();
		sess.close();	
		
	}



}