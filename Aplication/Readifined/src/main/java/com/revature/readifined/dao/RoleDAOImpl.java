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
import com.revature.readifined.domain.Role;

@Component
public class RoleDAOImpl implements RoleDAO{

	private SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory;
	}

	public Role getRole(int id) {
		Session sess = sf.openSession();
		Role p = sess.get(Role.class, id);
		sess.close();
		return p;
	}

	public Role getRole(String roleName) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<Role> cq = cb.createQuery(Role.class);
		Root<Role> rootEntry = cq.from(Role.class);
		CriteriaQuery<Role> all = cq.select(rootEntry).where(cb.equal(rootEntry.get("roleType"), roleName));
		TypedQuery<Role> allQuery = sess.createQuery(all);
		List<Role>list=allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);
	}

	public void saveRole(Role r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(r);
		tx.commit();
		sess.close();
	}

	public void updateRole(Role r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(r);
		tx.commit();
		sess.close();
		
	}

	public void deleteRole(Role r) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(r);
		tx.commit();
		sess.close();
	}



}
