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
import com.revature.readifined.domain.RegisteredRole;

@Component
public class RegisteredRoleDAOImpl implements RegisteredRoleDAO{
 
	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}

	public RegisteredRole getRegisteredRole(int id) {
		Session sess = sf.openSession();
		RegisteredRole rr = sess.get(RegisteredRole.class, id);
		sess.close();
		return rr;
	}

	public RegisteredRole getRegisteredRole(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<RegisteredRole> cq = cb.createQuery(RegisteredRole.class);
		Root<RegisteredRole> rootEntry = cq.from(RegisteredRole.class);
		CriteriaQuery<RegisteredRole> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<RegisteredRole> allQuery = sess.createQuery(all);
		List<RegisteredRole>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}


	public void saveRegisteredRole(RegisteredRole rr) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(rr);
		tx.commit();
		sess.close();
	}

	public void updateRegisteredRole(RegisteredRole rr) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(rr);
		tx.commit();
		sess.close();
	}

	public void deleteRegisteredRole(RegisteredRole rr) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(rr);
		tx.commit();
		sess.close();
	}


}
