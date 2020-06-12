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
import com.revature.readifined.domain.RegisteredAddress;

public class RegisteredAddressDAOImpl implements RegisteredAddressDAO {

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory; 
	}
	
	@Override
	public RegisteredAddress getRegisteredAddress(int id) {
		Session sess = sf.openSession();
		RegisteredAddress ra = sess.get(RegisteredAddress.class, id);
		sess.close();
		return ra;
	}

	@Override
	public RegisteredAddress getRegisteredAddress(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<RegisteredAddress> cq = cb.createQuery(RegisteredAddress.class);
		Root<RegisteredAddress> rootEntry = cq.from(RegisteredAddress.class);
		CriteriaQuery<RegisteredAddress> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<RegisteredAddress> allQuery = sess.createQuery(all);
		List<RegisteredAddress> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);	
	}

	@Override
	public void saveRegisteredAddress(RegisteredAddress ra) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(ra);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateRegisteredAddress(RegisteredAddress ra) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(ra);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteRegisteredAddress(RegisteredAddress ra) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(ra);
		tx.commit();
		sess.close();
	}

}