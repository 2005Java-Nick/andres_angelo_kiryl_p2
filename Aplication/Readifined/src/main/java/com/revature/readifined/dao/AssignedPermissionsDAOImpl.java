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

import com.revature.readifined.domain.AssignedPermissions;
@Repository
public class AssignedPermissionsDAOImpl implements AssignedPermissionsDAO {

public SessionFactory sf;
	
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sf = sessionFactory; 
	}	
	
	
	@Override
	public AssignedPermissions getAssignedPermissions(int id) {
		Session sess = sf.openSession();
		AssignedPermissions ap = sess.get(AssignedPermissions.class, id);
		sess.close();
		return ap;
	}

	@Override
	public AssignedPermissions getAssignedPermissions(int value, String column) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		CriteriaBuilder cb = sess.getCriteriaBuilder();
		CriteriaQuery<AssignedPermissions> cq = cb.createQuery(AssignedPermissions.class);
		Root<AssignedPermissions> rootEntry = cq.from(AssignedPermissions.class);
		CriteriaQuery<AssignedPermissions> all = cq.select(rootEntry).where(cb.equal(rootEntry.get(column), value));
		TypedQuery<AssignedPermissions> allQuery = sess.createQuery(all);
		List<AssignedPermissions> list = allQuery.getResultList();
		tx.commit();
		sess.close();
		return list.get(0);	
	}

	@Override
	public void saveAssignedPermissions(AssignedPermissions ap) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.save(ap);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void updateAssignedPermissions(AssignedPermissions ap) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.update(ap);
		tx.commit();
		sess.close();
		
	}

	@Override
	public void deleteAssignedPermissions(AssignedPermissions ap) {
		Session sess = sf.openSession();
		Transaction tx = sess.beginTransaction();
		sess.delete(ap);
		tx.commit();
		sess.close();
		
	}

}
