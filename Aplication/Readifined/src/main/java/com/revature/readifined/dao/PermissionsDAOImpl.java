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

import com.revature.readifined.domain.Permissions;

public class PermissionsDAOImpl implements PermissionsDAO{

    private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}
	
	
	@Override
	public Permissions getPermissions(int id) {
		Session sess = sf.openSession();
		Permissions pm = sess.get(Permissions.class, id);
		sess.close();
		return pm;
	}

	@Override
	public Permissions getPermissions(String value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Permissions> cq = cb.createQuery(Permissions.class);
		Root<Permissions> rootEntry = cq.from(Permissions.class);
		CriteriaQuery<Permissions> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<Permissions> allQuery = sess.createQuery(all);
		List<Permissions>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	@Override
	public void savePermissions(Permissions pm) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(pm);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updatePermissions(Permissions pm) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(pm);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deletePermissions(Permissions pm) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(pm);
		tx.commit();
		sess.close();
		
	}

}
